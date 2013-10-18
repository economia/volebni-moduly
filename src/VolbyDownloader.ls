require! {
    async
    http
    iconv.Iconv
    "../data/struktura.json"
    xml2js
    request
    moment
    fs
    events.EventEmitter
}
iconv = new Iconv 'iso-8859-2' 'utf-8'
module.exports = class VolbyDowloader extends EventEmitter
    prefix: null
    minimumInterval: 15
    sources: [
        {url: \vysledky interval: 30 type: \kraje short: \kraje}
        {url: \vysledky_kandid interval: 60 type: \preferencni short: \preferencni}
    ]
    (config) ->
        @prefix = config.prefix
        struktura.okresy.forEach ~>
            @sources.push do
                url: "vysledky_okres?nuts=#{it.id}"
                interval: 60
                type: \obce
                short: "obce-#{it.id}"

    start: ->
        @sources.forEach (source, index) ~>
            @downloadSourceIn source, index

    downloadSource: (source) ->
        opts =
            uri: @prefix + source.url
            encoding: null
        (err, response, body) <~ request.get opts
        console.log "Downloaded #{source.short}"
        if err or not body.length
            if err
                console.error "Error downloading #{opts.uri}", err
            else
                console.error "Error downloading #{opts.uri}: zero content length"
            @downloadSourceIn source, 15
            return
        data = iconv.convert body
        (err, xml) <~ xml2js.parseString data
        try
            throw err if err
            root = switch source.type
                | \kraje => xml.VYSLEDKY
                | \preferencni => xml.VYSLEDKY_KANDID
                | \obce => xml.VYSLEDKY_OKRES

            date = root.$.DATUM_GENEROVANI
            time = root.$.CAS_GENEROVANI
            generated = moment do
                date + " " + time + " +0200"
                "DD/MM/YYYY HH:mm:ss Z"
            difference = Date.now! - generated.valueOf!
            difference /= 1000
            difference = Math.floor difference
            interval = source.interval - difference
            if interval < @minimumInterval then interval = @minimumInterval
            niceTime = moment!format "YYYY-MM-DD-HH-mm-ss"
            @downloadSourceIn source, interval + 2
            console.log "Parsed #{source.short}. Next download in #{interval + 2}"
            @emit do
                source.type
                xml
                data
            fs.writeFile "#__dirname/../data/output/#{niceTime}-#{source.short}", data

        catch ex
            console.error "Error parsing #{opts.uri}", ex
            @downloadSourceIn source, 15

    downloadSourceIn: (source, seconds) ->
        fn = ~> @downloadSource source
        setTimeout fn, seconds * 1e3
