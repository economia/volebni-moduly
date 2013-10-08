module.exports.compute = (partyArray, mandateCount, options = {}) ->
    options.base ?= 1
    mandates = partyArray.map -> 0
    votes =
        | options.voteAccessor => partyArray.map that
        | otherwise            => partyArray
    if options.resultProperty then partyArray.forEach -> it[that] = 0
    dividers = [1 to mandateCount]
    if options.base then dividers.0 = that
    scores = []
    dividers.forEach (divider) ->
        votes.forEach (voteCount, index) ->
            score = voteCount / divider
            scores.push {score, index}
    scores.sort (a, b) -> b.score - a.score
    mandatesAwarded = 0
    for {score, index} in scores
        if mandatesAwarded < mandateCount
            mandates[index]++
            if options.resultProperty then partyArray[index][that]++
            mandatesAwarded++
        else
            break
    mandates
