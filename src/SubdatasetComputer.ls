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

    getCountry: ->
        parties = @getParties!
        attendance_max    = 0
        attendance_actual = 0
        processed_target  = 0
        processed_actual  = 0
        @dataset.forEach (county) ->
            attendance_max    += county.attendance_max
            attendance_actual += county.attendance_actual
            processed_target  += county.processed_target
            processed_actual  += county.processed_actual

        {attendance_max, attendance_actual, processed_target, processed_actual, parties}

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
                    {name, surname, partyId, countyId, rank, votedRank, mandate} = candidate
                    return if not mandate
                    newLength = output.push {name, surname, partyId, countyId, rank, votedRank}
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
