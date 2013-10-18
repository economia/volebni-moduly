require! {
    fs
    redis
    moment
    xml2js
    events.EventEmitter
}
module.exports = class DownloadSimulator extends EventEmitter
    ->
        (err, files) <~ fs.readdir "#__dirname/../data/output"
        records = files.map ->
            time = moment it, "YYYY-MM-DD-HH-mm-ss"
            name: it
            date: time.format "HH:mm:ss"
            time: time.format "X"
        records.sort (a, b) -> a.time - b.time
        firstTime = records[0].time
        @offsets = []
        records.forEach ~>
            offset = it.time - firstTime
            @offsets[offset] ?= []
                ..push it
        @currentOffset = 100
        # @offsets = []
        # @offsets[0] =
        #     *   name: \2013-10-18-11-15-23-kraje
        #     *   name: \2013-10-18-11-14-29-preferencni

    start: ->
        setInterval @~loadNext, 100

    loadNext: ->
        records = @offsets[@currentOffset]
        @currentOffset++
        return if not records
        records.forEach ({name}) ~>
            parts = name.split "-"
            type = parts.pop!
            if type not in <[kraje preferencni]>
                type = 'obce'
            (err, content) <~ fs.readFile "#__dirname/../data/output/#name"
            (err, xml) <~ xml2js.parseString content
            @emit type, xml


