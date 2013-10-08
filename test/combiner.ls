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

    test "counties should have their parties" ->
        expect result.0 .to.have.property \name "Hl. m. Praha"
        expect result.0 .to.have.property \parties
        expect result.0.parties.0 .to.have.property \abbr "Občané"

    test "county parties should have their candidates" ->
        expect result.0.parties.0 .to.have.property \candidates
        candidates = result.0.parties.0.candidates
        expect candidates .to.be.an \array
        expect candidates .to.have.length 36
        expect candidates.0 .to.have.property \surname "Havlík"
        expect candidates.0 .to.have.property \rank 1
