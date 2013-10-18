require! {
    expect : "expect.js"
    fs
    Parser: "../src/parser_obce"
    parser_parties: "../src/parser_parties"
    xml2js
}

test = it
describe "Parser for obce" ->
    okresXml = null
    parser = null
    parties = null
    receivedData = {}
    before (done) ->
        (err, data) <~ fs.readFile "#__dirname/data/vysledky_okres.xml"
        (err, okres) <~ xml2js.parseString data
        okresXml := okres
        (err, data) <~ fs.readFile "#__dirname/data/strany.csv"
        parties := parser_parties.parse data.toString!
        done!

    test "should construct" ->
        parser := new Parser parties
            ..on \item (id, content) ->  receivedData[id] := content

    test "should parse the XML" ->
        parser.parse okresXml

    test "should have result for event not-fully-counted okres" ->
        expect receivedData .to.have.property \CZ0312
        expect receivedData['CZ0312'] .to.have.property \attendance_max 3822
        expect receivedData['CZ0312'] .to.have.property \attendance_actual 3263
        expect receivedData['CZ0312'] .to.have.property \processed_target 79
        expect receivedData['CZ0312'] .to.have.property \processed_actual 9
        expect receivedData['CZ0312'] .to.have.property \parties
        expect receivedData['CZ0312'].parties.0 .to.have.property \id 1
        expect receivedData['CZ0312'].parties.0 .to.have.property \votes_sum 126
        expect receivedData['CZ0312'].parties.0 .to.have.property \votes_sum_percent 0.0405

    test "should detect correct obce-level results" ->
        expect receivedData .to.have.property \545406
        expect receivedData['545406'] .to.have.property \parties
        expect receivedData['545406'].parties.0 .to.have.property \id 1
        expect receivedData['545406'].parties.0 .to.have.property \votes_sum 13
        expect receivedData['545406'].parties.0 .to.have.property \votes_sum_percent 0.039
