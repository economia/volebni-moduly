require! {
    xml2js
}
module.exports.parse_county_list = (xmlString, cb) ->
    (err, xml) <~ xml2js.parseString xmlString
    cb err if err
    cb null, xml["VYSLEDKY_KRAJMESTA"]["KRAJ"].map (kraj) ->
        name = kraj.$.NAZ_KRAJ
        id = +kraj.$.CIS_KRAJ
        {id, name}


