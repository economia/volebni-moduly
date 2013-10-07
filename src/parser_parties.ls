module.exports.parse = (csvString, cb) ->
    lines = csvString.split "\n"
    lines.shift! # headers
    lines.filter -> it.length


