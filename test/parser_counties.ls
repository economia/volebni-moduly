require! {
    expect : "expect.js"
    fs
    parser: "../src/parser_counties"
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
        expect list.0 .to.have.property \parties
        expect list.0.parties .to.have.length 21
        expect list.0.parties.0 .to.have.property \id 1
        expect list.0.parties.0 .to.have.property \votes 1246

