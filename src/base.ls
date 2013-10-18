require! {
    # "./VolbyDownloader"
    VolbyDownloader: "./DownloadSimulator"
    "./parser_parties"
    "./parser_candidates"
    "./parser_counties"
    "./SubdatasetComputer"
    "./combiner"
    "./RedisSaver"
    "./config"
    fs
    redis
}
redisClient = redis.createClient config.redis.port, config.redis.host
redisSaver = new RedisSaver redisClient
subdatasetComputer = new SubdatasetComputer
(err, candidatesCsv) <~ fs.readFile "#__dirname/../data/kandidati.csv"
candidatesCsv .= toString!
(err, partiesCsv) <~ fs.readFile "#__dirname/../data/strany.csv"
parties = parser_parties.parse partiesCsv.toString!
volbyDownloader = new VolbyDownloader config.downloader
volbyDownloader.start!
counties = null
candidates = null
obce = null
recompute = ->
    try
        return unless counties && candidates && parties
        result = combiner.combine counties, parties, candidates
        combiner.compute result
        subdatasetComputer.setBaseDataset result
        redisSaver
            ..saveResults result
            ..saveCandidates subdatasetComputer.getCandidates!
            ..saveParties subdatasetComputer.getParties!
    catch ex
        console.error "Error in postprocess: ", ex

volbyDownloader.on \kraje (xml) ->
    console.log "Kraje loaded"
    try
        counties := parser_counties.parse xml
        recompute!
    catch ex
        console.error "Error in computing", ex

volbyDownloader.on \preferencni (xml) ->
    console.log "Preference loaded"
    try
        candidates := parser_candidates.parse candidatesCsv, xml
        recompute!
    catch ex
        console.error "Error in computing", ex

volbyDownloader.on \obce ->
    console.log "Obec loaded"
