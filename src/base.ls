require! {
    "./VolbyDownloader"
    "./parser_parties"
    "./parser_candidates"
    "./parser_counties"
    "./SubdatasetComputer"
    "./combiner"
    "./RedisSaver"
    fs
    redis
}
redisClient = redis.createClient 6379 "192.168.123.57"
redisSaver = new RedisSaver redisClient
subdatasetComputer = new SubdatasetComputer
(err, candidatesCsv) <~ fs.readFile "#__dirname/../data/kandidati.csv"
candidatesCsv .= toString!
(err, partiesCsv) <~ fs.readFile "#__dirname/../data/strany.csv"
parties = parser_parties.parse partiesCsv.toString!
volbyDownloader = new VolbyDownloader
volbyDownloader.start!
counties = null
candidates = null
obce = null
recompute = ->
    return unless counties && candidates && parties
    result = combiner.combine counties, parties, candidates
    combiner.compute result
    subdatasetComputer.setBaseDataset result
    redisSaver
        ..saveResults result
        ..saveCandidates subdatasetComputer.getCandidates!
        ..saveParties subdatasetComputer.getParties!

volbyDownloader.on \kraje (xml) ->
    console.log "Kraje loaded"
    counties := parser_counties.parse xml
    recompute!

volbyDownloader.on \preferencni (xml) ->
    candidates := parser_candidates.parse candidatesCsv, xml
    console.log "Preference loaded"
    recompute!

volbyDownloader.on \obce ->
    console.log "Obec loaded"
