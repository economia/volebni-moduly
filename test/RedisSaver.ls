require! {
    expect : "expect.js"
    "../src/RedisSaver"
    "./config.ls"
    redis
    fs
}

test = it
describe "Redis saver" ->
    redisClient = null
    before (done) ->
        redisClient := redis.createClient config.redis.port, config.redis.host
        <~ redisClient.select config.redis.db
        <~ redisClient.flushdb!
        done!
    after (done) ->
        <~ redisClient.flushdb!
        done!
    redisSaver = null
    test "should initialize" ->
        redisSaver := new RedisSaver redisClient

    describe "all results datafile" ->
        results = null
        redisListener = null
        messagesFired = 0
        before (done) ->
            redisListener := redis.createClient config.redis.port, config.redis.host
            <~ redisListener.select config.redis.db
            (err, raw) <~ fs.readFile "#__dirname/data/sampleResult.json"
            results := JSON.parse raw.toString!
            expect raw.length .to.be.above 1e6
            done!

        test "should PUBlish results " (done) ->
            redisListener
                ..subscribe "results"
                ..on \message (channel, message) ->
                    expect message .to.equal JSON.stringify results
                    messagesFired++
                    done! if messagesFired == 1
            redisSaver.saveResults results

        test "results should be saved in DB" (done) ->
            (err, data) <~ redisClient.get "results"
            expect data .to.equal JSON.stringify results
            done!


        test "same results should not fire PUB event" (done) ->
            redisSaver.saveResults results
            <~ setTimeout _, 100
            expect messagesFired .to.equal 1
            done!




    describe "parties datafile" ->
        parties = null
        redisListener = null
        before (done) ->
            redisListener := redis.createClient config.redis.port, config.redis.host
            <~ redisListener.select config.redis.db
            (err, raw) <~ fs.readFile "#__dirname/data/sampleParties.json"
            parties := JSON.parse raw.toString!
            done!

        test "should PUBlish parties " (done) ->
            redisListener
                ..subscribe "parties"
                ..on \message (channel, message) ->
                    expect message .to.equal JSON.stringify parties
                    done!
            redisSaver.saveParties parties

        test "parties should be saved in DB" (done) ->
            (err, data) <~ redisClient.get "parties"
            expect data .to.equal JSON.stringify parties
            done!


    describe "candidates datafile" ->
        candidates = null
        redisListener = null
        before (done) ->
            redisListener := redis.createClient config.redis.port, config.redis.host
            <~ redisListener.select config.redis.db
            (err, raw) <~ fs.readFile "#__dirname/data/sampleCandidates.json"
            candidates := JSON.parse raw.toString!
            done!

        test "should PUBlish candidates " (done) ->
            redisListener
                ..subscribe "candidates"
                ..on \message (channel, message) ->
                    expect message .to.equal JSON.stringify candidates
                    done!
            redisSaver.saveCandidates candidates

        test "candidates should be saved in DB" (done) ->
            (err, data) <~ redisClient.get "candidates"
            expect data .to.equal JSON.stringify candidates
            done!

    describe "per-obec results" ->
        obecId = 123
        values = [123 456 789]
        redisListener = null
        messagesFired = 0
        before (done) ->
            redisListener := redis.createClient config.redis.port, config.redis.host
            <~ redisListener.select config.redis.db
            done!

        test "should PUBlish new records" (done) ->
            redisListener
                ..subscribe "obce"
                ..on \message (channel, message) ->
                    message = JSON.parse message
                    expect message .to.have.property \id obecId
                    expect message.values .to.eql values
                    messagesFired++
                    done! if messagesFired == 1
            redisSaver.saveObec obecId, values


        test "results should be saved in DB" (done) ->
            (err, data) <~ redisClient.hget "obce" obecId
            data = JSON.parse data
            expect data .to.eql values
            done!

        test "same results should not fire PUB event" (done) ->
            redisSaver.saveObec obecId, values
            <~ setTimeout _, 100
            expect messagesFired .to.equal 1
            done!


