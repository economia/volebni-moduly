require! {
    xml2js
}
module.exports.parse = (csvString, preferentialVotesString, cb) ->
    (err, preferentialVotesAssoc) <~ computePreferentialVotes preferentialVotesString
    cb err if err
    lines = csvString.split "\n"
    lines.shift! # headers
    list = lines
        .filter -> it.length
        .map (line) ->
            [countyId, partyId, rank, name, surname, title1, title2] = line.split ";"
            countyId = +countyId
            partyId  = +partyId
            rank     = +rank
            id       = getCandidateId countyId, partyId, rank
            votes    = +preferentialVotesAssoc[id]
            {countyId, partyId, rank, name, surname, title1, title2, votes}
        .sort (a, b) ->
            | a.countyId - b.countyId => that
            | a.partyId - b.partyId   => that
            | otherwise               => a.rank - b.rank
    cb null list

computePreferentialVotes = (preferentialVotesString, cb) ->
    (err, xml) <~ xml2js.parseString preferentialVotesString
    preferentialVotesAssoc = {}
    xml.VYSLEDKY_KANDID.KRAJ.forEach (county) ->
        countyId = +county.$.CIS_KRAJ
        county.KANDIDATI.0.KANDIDAT.forEach (candidate) ->
            partyId = +candidate.$.KSTRANA
            rank = +candidate.$.PORCISLO
            votes = +candidate.$.HLASY
            id = getCandidateId countyId, partyId, rank
            preferentialVotesAssoc[id] = votes

    cb null preferentialVotesAssoc

getCandidateId = (countyId, partyId, rank) ->
    "#countyId-#partyId-#rank"
