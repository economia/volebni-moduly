require! async
module.exports = class RedisSaver
    (@redisClient) ->

    saveResults: (results, cb) ->
        data = JSON.stringify results
        (err) <~ @save \results data
        cb? err

    saveCandidates: (candidates, cb) ->
        data = JSON.stringify candidates
        (err) <~ @save \candidates data
        cb? err

    saveParties: (parties, cb) ->
        data = JSON.stringify parties
        (err) <~ @save \parties data
        cb? err

    saveObec: (obecId, values, cb) ->
        pubObject = {}
        pubObject[obecId] = values
        pubValue = JSON.stringify pubObject
        hashValue = JSON.stringify values
        (err, existingValue) <~ @redisClient.hget \obce, obecId
        return cb? null if existingValue == hashValue
        (err) <~ async.parallel do
            *   (cb) ~>
                    @redisClient.hset do
                        \obce
                        obecId
                        hashValue
                        cb
                (cb) ~> @redisClient.publish do
                    \obce
                    pubValue
                    cb
        cb? err

    save: (field, data, cb) ->
        (err, existingData) <~ @redisClient.get field
        return cb? null if existingData == data
        (err, [rSet, rPub]) <~ async.parallel do
            *   (cb) ~> @redisClient.set field, data, cb
                (cb) ~> @redisClient.publish field, data, cb
        cb err, [rSet, rPub]
