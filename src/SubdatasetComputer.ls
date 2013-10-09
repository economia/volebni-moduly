module.exports = class SubdatasetComputer
    ->
    setBaseDataset: (@dataset) ->

    getParties: ->
        partyIds_processed = []
        output = []
        @forEachParty (party) ->
            return if party.id in partyIds_processed
            {id, name, abbr, votes_sum, votes_sum_percent} = party
            votes_sum_percent = parseFloat votes_sum_percent.toFixed 4
            output.push {id, name, abbr, votes_sum, votes_sum_percent}
            partyIds_processed.push id
        output

    getCandidates: ->
        output = @loadCandidates!
        @sortCandidates output
        output

    loadCandidates: ->
        output = []
        @dataset.forEach ({parties}:county) ->
            countyLowestScore = +Infinity
            countyLowestCandidate = null
            countyClosestParty = null
            parties.forEach ({candidates}:party) ->
                if party.requiredVotes
                    countyClosestParty := party

                lastCandidateIndex = null
                candidates.forEach (candidate) ->
                    {name, surname, partyId, rank, votedRank, mandate} = candidate
                    return if not mandate
                    newLength = output.push {name, surname, partyId, rank, votedRank}
                    lastCandidateIndex := newLength - 1
                if party.lowestScore < countyLowestScore
                    countyLowestScore     := party.lowestScore
                    countyLowestCandidate := output[lastCandidateIndex]
            return unless countyLowestCandidate && countyClosestParty
            if countyLowestCandidate.partyId != countyClosestParty.id
                countyLowestCandidate
                    ..leadByVotes   = Math.round countyClosestParty.requiredVotes
                    ..leadByScore   = Math.round countyClosestParty.requiredScore
                    ..score         = Math.round countyLowestScore
                    ..leadFromParty = countyClosestParty.id
        output

    sortCandidates: (candidates) ->
        candidates.sort (a, b) ->
            | a.partyId - b.partyId => that
            | a.votedRank - b.votedRank => that
            | otherwise => a.rank - b.rank

    forEachParty: (fn) ->
        @dataset.forEach ({parties}:county) ->
            parties.forEach fn
