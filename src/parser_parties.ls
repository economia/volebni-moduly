module.exports.parse = (csvString, cb) ->
    lines = csvString.split "\n"
    lines.shift! # headers
    lines
        .filter -> it.length
        .map (line) ->
            [id, _, name, _, _, abbr] = line.split ";"
            id = +id
            {id, name, abbr}


