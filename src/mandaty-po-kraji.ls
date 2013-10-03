module.exports.compute = (kraje, mandateCount, options) ->
    values = loadValues kraje, options
    total               = values.reduce sum
    mandateNumber       = Math.round total / mandateCount
    mandatesRaw         = values.map -> it / mandateNumber
    mandateRemainders   = mandatesRaw.map -> it % 1
    mandatesReceived    = mandatesRaw.map -> Math.floor it
    currentMandateCount = mandatesReceived.reduce sum
    while currentMandateCount < mandateCount
        index = getBiggestMandateRemainderIndex mandateRemainders
        mandateRemainders[index] = 0
        mandatesReceived[index]  += 1
        currentMandateCount      += 1

    if options.resultProperty
        kraje.forEach (kraj, index) -> kraj[that] = mandatesReceived[index]
        kraje
    else
        mandatesReceived

getBiggestMandateRemainderIndex = (mandateRemainders) ->
    maxRemainder = -Infinity
    maxIndex = null
    for mandateRemainder, index in mandateRemainders
        if mandateRemainder > maxRemainder
            maxRemainder = mandateRemainder
            maxIndex     = index
    maxIndex

loadValues = (kraje, options) ->
    | options.countAccessor => kraje.map -> that it
    | otherwise => kraje

sum = (sum, curr) -> (sum || 0) + curr
