require! {
    expect : "expect.js"
    fs
    "../src/parser_parties"
    "../src/parser_candidates"
    "../src/parser_counties"
    "../src/combiner"
}
test = it
describe "Parser for counties" ->
    counties   = null
    parties    = null
    candidates = null
    result     = null
    before (done) ->
        (err, volbyXml) <~ fs.readFile "#__dirname/data/vysledky_krajmesta.xml"
        (err, parsedXml) <~ parser_counties.parse_county_list volbyXml
        counties := parsedXml
        (err, data) <~ fs.readFile "#__dirname/data/strany.csv"
        data .= toString!
        parties := parser_parties.parse data
        (err, data) <~ fs.readFile "#__dirname/data/kandidati.csv"
        data .= toString!
        candidates := parser_candidates.parse data
        done!

    test "should combine results" ->
        result := combiner.combine counties, parties, candidates
        expect result .to.be.an \array
