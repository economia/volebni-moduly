require! {
    expect : "expect.js"
    fs
    parser: "../src/parser_candidates"
}

test = it
describe "Parser for candidates" ->
    candidatesString = null
    preferentialVotesString = null
    list = null
    before (done) ->
        (err, data) <~ fs.readFile "#__dirname/data/kandidati.csv"
        candidatesString := data.toString!
        (err, data) <~ fs.readFile "#__dirname/data/vysledky_kandid.xml"
        preferentialVotesString := data.toString!
        done!

    test "should parse the CSV" (done) ->
        (err, result) <~ parser.parse candidatesString, preferentialVotesString
        expect err .to.be null
        expect result .to.be.an \array
        list := result
        done!

    test "should get all candidates" ->
        expect list .to.have.length 5059

    test "candidates should have correct properties" ->
        expect list.0 .to.have.property \countyId 1
        expect list.0 .to.have.property \partyId 1
        expect list.0 .to.have.property \rank 1
        expect list.0 .to.have.property \surname "Havlík"
        expect list.5058 .to.have.property \countyId 14
        expect list.5058 .to.have.property \partyId 26
        expect list.5058 .to.have.property \rank 36
        expect list.5058 .to.have.property \surname "Hrabec"
        expect list.5058 .to.have.property \name "Lukáš"

    test "candidates should have their preferential votes computed" ->
        expect list.0 .to.have.property \votes 162
        expect list.5058 .to.have.property \votes 3531
