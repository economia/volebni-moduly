require! {
    expect : "expect.js"
    fs
    parser: "../src/parser_parties"
}

test = it
describe "Parser for parties" ->
    partiesString = null
    list = null
    before (done) ->
        (err, data) <~ fs.readFile "#__dirname/data/strany.csv"
        partiesString := data.toString!
        done!

    test "should parse the CSV" ->
        list := parser.parse partiesString
        expect list .to.be.an \array

    test "should get all parties" ->
        expect list .to.have.length 27

    test "parties should have correct properties" ->
        expect list.0 .to.have.property \id 1
        expect list.0 .to.have.property \name "OBČANÉ.CZ"
        expect list.0 .to.have.property \abbr "Občané"

