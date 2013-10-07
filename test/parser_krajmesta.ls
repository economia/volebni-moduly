require! {
    expect : "expect.js"
    fs
    parser: "../src/parser_krajmesta"
}
test = it
describe "Parser for counties" ->
    xml = null
    list = null
    before (done) ->
        (err, volbyXml) <~ fs.readFile "#__dirname/data/vysledky_krajmesta.xml"
        xml := volbyXml.toString!
        done!
    test "should parse the XML" (done) ->
        (err, parsedXml) <~ parser.parse_county_list xml
        expect err .to.be null
        list := parsedXml
        done!
    test "should produce a list of counties" ->
        expect list .to.have.length 14
        expect list.0 .to.have.property \id 1
        expect list.0 .to.have.property \name "Hl. m. Praha"

    test "should compute vote counts per county" ->
        expect list.2 .to.have.property \votes 333117

    test "should compute raw party results" ->
        expect list.0 .to.have.property \party_votes
        expect list.0.party_votes .to.have.property \1 1246
        expect list.0.party_votes .to.have.property \27 1099

