require! {
    # request
    # iconv.Iconv
    expect : "expect.js"
    xml: xml2js
    fs
    mandaty: "../lib/mandaty-po-kraji"
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
        expect kraje .to.not.be null
        expect kraje .to.have.length 14
        expect kraje.0 .to.have.property \nazev 'Hl. m. Praha'
        expect kraje.0 .to.have.property \platneHlasy 637328

    test 'should compute test case correctly' ->
        result = mandaty.compute kraje, 200, countAccessor: -> it.platneHlasy
        expect result .to.eql [25 24 13 11 5 14 8 11 10 10 23 12 12 22]

    test 'result accessor should work' ->
        result = mandaty.compute do
            *   kraje
            *   200
            *   countAccessor: -> it.platneHlasy
                resultProperty: "mandaty"
        expect result.0 .to.have.property \mandaty 25
        expect result.13 .to.have.property \mandaty 22

