require! {
    expect : "expect.js"
    fs
    parser: "../src/parser_counties"
    xml2js
}
test = it
describe "Parser for counties" ->
    xml = null
    list = null
    describe "Parsing from krajmesta dataset" ->
        before (done) ->
            (err, volbyXml) <~ fs.readFile "#__dirname/data/vysledky_krajmesta.xml"
            (err, data) <~ xml2js.parseString volbyXml
            xml := data
            done!

        test "should parse the XML" (done) ->
            parsedXml = parser.parse xml
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
    describe "parsing from main dataset" ->
        before (done) ->
            (err, volbyXml) <~ fs.readFile "#__dirname/data/vysledky.xml"
            (err, data) <~ xml2js.parseString volbyXml
            xml := data
            done!

        test "should parse the XML" (done) ->
            parsedXml = parser.parse xml
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

