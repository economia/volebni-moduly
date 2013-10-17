require! {
    xml2js
}
module.exports.parse = (csvString, preferentialVotesXml) ->
    preferentialVotesAssoc = computePreferentialVotes preferentialVotesXml
    lines = csvString.split "\n"
    lines.shift! # headers
    list = lines
        .filter -> it.length
        .map (line) ->
            [countyId, partyId, rank, name, surname, title1, title2, age, occupation, residence, residenceCode, party, suggParty, isInvalid] = line.split ";"
            return null if isInvalid == "1"
            countyId = +countyId
            partyId  = +partyId
            rank     = +rank
            id       = getCandidateId countyId, partyId, rank
            votes    = +preferentialVotesAssoc[id]
            {countyId, partyId, rank, name, surname, title1, title2, votes}
        .filter -> it isnt null
        .sort (a, b) ->
            | a.countyId - b.countyId => that
            | a.partyId - b.partyId   => that
            | otherwise               => a.rank - b.rank
    list

computePreferentialVotes = (preferentialVotesXml) ->
    preferentialVotesAssoc = {}
    preferentialVotesXml.VYSLEDKY_KANDID.KRAJ.forEach (county) ->
        countyId = +county.$.CIS_KRAJ
        county.KANDIDATI.0.KANDIDAT.forEach (candidate) ->
            partyId = +candidate.$.KSTRANA
            rank = +candidate.$.PORCISLO
            votes = +candidate.$.HLASY
            id = getCandidateId countyId, partyId, rank
            preferentialVotesAssoc[id] = votes

    preferentialVotesAssoc

getCandidateId = (countyId, partyId, rank) ->
    "#countyId-#partyId-#rank"
