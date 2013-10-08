module.exports.parse = (csvString, cb) ->
    lines = csvString.split "\n"
    lines.shift! # headers
    lines
        .filter -> it.length
        .map (line) ->
            [countyId, partyId, rank, name, surname, title1, title2] = line.split ";"
            countyId = +countyId
            partyId  = +partyId
            rank     = +rank
            {countyId, partyId, rank, name, surname, title1, title2}
        .sort (a, b) ->
            | a.countyId - b.countyId => that
            | a.partyId - b.partyId   => that
            | otherwise               => a.rank - b.rank
