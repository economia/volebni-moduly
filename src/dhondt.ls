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
            scores.push {score, index, divider}
    scores.sort (a, b) ->
        | b.score - a.score => that
        | a.index - b.index => that
        | otherwise         => 0
    mandatesAwarded = 0
    for {score, index, divider}, scoreIndex in scores
        if mandatesAwarded < mandateCount
            mandates[index]++
            if options.resultProperty then partyArray[index][that]++
            if options.lowestScoreProperty then partyArray[index][that] = score
        else if mandatesAwarded == mandateCount
            lastScore = scores[scoreIndex - 1]
            break if lastScore.index == index
            scoreDiff = lastScore.score - score
            if options.requiredVotesProperty
                partyArray[index][that] = scoreDiff * divider
            if options.requiredScoreProperty
                partyArray[index][that] = scoreDiff
        else
            break
        mandatesAwarded++
    mandates
