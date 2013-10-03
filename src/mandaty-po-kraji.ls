module.exports.compute = (kraje, mandateCount, options) ->
    values = switch
        | options.countAccessor => kraje.map -> that it
        | otherwise => kraje
    total = values.reduce sum
    mandateNumber = Math.round total / mandateCount
    mandatesRaw = values.map -> it / mandateNumber
    mandatesReceived = mandatesRaw.map -> Math.floor it
    mandateRemainders = mandatesRaw.map -> it % 1
    currentMandateCount = mandatesReceived.reduce sum
    while currentMandateCount < mandateCount
        maxRemainder = -Infinity
        maxIndex = null
        for mandateRemainder, index in mandateRemainders
            if mandateRemainder > maxRemainder
                maxRemainder = mandateRemainder
                maxIndex     = index
        mandateRemainders[maxIndex] = 0
        mandatesReceived[maxIndex] += 1
        currentMandateCount += 1
    mandatesReceived


sum = (sum, curr) -> (sum || 0) + curr
