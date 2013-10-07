require! {
    expect : "expect.js"
    fs
    parser: "../src/parser_krajmesta"
}
test = it
describe "Parser for counties" ->
    xml = null
    before (done) ->
        (err, volbyXml) <~ fs.readFile "#__dirname/data/vysledky_krajmesta.xml"
        xml := volbyXml.toString!
        done!
    test "should produce a list of counties" (done) ->
        (err, list) <~ parser.parse_county_list xml
        expect err .to.be null
        expect list .to.have.length 14
        expect list.0 .to.have.property \id 1
        expect list.0 .to.have.property \name "Hl. m. Praha"
        done!
