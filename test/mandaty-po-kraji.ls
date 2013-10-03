require! {
    # request
    # iconv.Iconv
    expect : "expect.js"
    xml: xml2js
    fs
}
# iconv = new Iconv 'iso-8859-2' 'utf-8'
test = it
class Kraj
    (@id, @nazev, @platneHlasy) ->
describe "Mandaty po krajich" ->
    kraje = null
    before (done) ->
        # (err, response, body) <~ request.get "http://www.volby.cz/pls/ps2010/vysledky_krajmesta", encoding: null
        # volbyXml = iconv.convert body
        # (err) <~ fs.writeFile "#__dirname/vysledky_krajmesta.xml" volbyXml
        (err, volbyXml) <~ fs.readFile "#__dirname/vysledky_krajmesta.xml"
        volbyXml .= toString!
        (err, result) <~ xml.parseString volbyXml
        kraje := result["VYSLEDKY_KRAJMESTA"]["KRAJ"].map (kraj) ->
            id = kraj["$"]["CIS_KRAJ"]
            nazev = kraj["$"]["NAZ_KRAJ"]
            hlasy = +kraj["CELKEM"][0]["UCAST"][0]["$"]["PLATNE_HLASY"]
            new Kraj id, nazev, hlasy
        done!
    test 'check data ' ->
        console.log kraje
        expect kraje .to.not.be null
