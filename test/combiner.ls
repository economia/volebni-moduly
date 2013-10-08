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

    test "parties should have sums of their votes computed" ->
        expect result.0.parties.0 .to.have.property \votes_sum 13397
        expect result.0.parties.1 .to.have.property \votes_percent
        vvPercent = Math.round result.0.parties.1.votes_percent * 100
        expect vvPercent .to.equal 11

    test "county parties should have their candidates" ->
        expect result.0.parties.0 .to.have.property \candidates
        candidates = result.0.parties.0.candidates
        expect candidates .to.be.an \array
        expect candidates .to.have.length 36
        expect candidates.0 .to.have.property \surname "Havlík"
        expect candidates.0 .to.have.property \rank 1

    test "should assign correct number of mandates" ->
        combiner.compute result
        expect result.0 .to.have.property \mandates 25
        expect result.1 .to.have.property \mandates 24

    test "should assign correct number of mandates to parties" ->
        prague = result.0
        expect prague.parties.0 .to.have.property \abbr "Občané"
        expect prague.parties.0 .to.have.property \mandates 0
        expect prague.parties.1 .to.have.property \abbr "VV"
        expect prague.parties.1 .to.have.property \mandates 3

    after (done) ->
        (err) <~ fs.writeFile "#__dirname/data/combined.json" JSON.stringify result, null "  "
        throw err if err
        done!
