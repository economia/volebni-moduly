module.exports.compute = (candidates, partyVotes, {voteAccessor, threshold}:options) ->
    preferredCandidates = []
    deferredCandidates = []
    candidates.forEach (candidate) ->
        candidateVotes = options.voteAccessor candidate
        percent = candidateVotes / partyVotes
        list = if percent >= options.threshold
            preferredCandidates
        else
            deferredCandidates
        list.push candidate

    preferredCandidates.sort (a, b) ->
        votesA = options.voteAccessor a
        votesB = options.voteAccessor b
        votesB - votesA

    preferredCandidates ++ deferredCandidates
