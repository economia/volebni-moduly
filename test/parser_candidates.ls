require! {
    expect : "expect.js"
    fs
    parser: "../src/parser_candidates"
}

test = it
describe "Parser for candidates" ->
    candidatesString = null
    list = null
    before (done) ->
        (err, data) <~ fs.readFile "#__dirname/data/kandidati.csv"
        candidatesString := data.toString!
        done!

    test "should parse the CSV" ->
        list := parser.parse candidatesString
        expect list .to.be.an \array

    test "should get all candidates" ->
        expect list .to.have.length 5906

    test "candidates should have correct properties" ->
        expect list.0 .to.have.property \countyId 1
        expect list.0 .to.have.property \partyId 1
        expect list.0 .to.have.property \rank 1
        expect list.0 .to.have.property \surname "Zavadil"
        expect list.5905 .to.have.property \countyId 14
        expect list.5905 .to.have.property \partyId 24
        expect list.5905 .to.have.property \rank 36
        expect list.5905 .to.have.property \surname "Syslo"
        expect list.5905 .to.have.property \name "Milan"

