module.exports = class SubdatasetComputer
    ->
    setBaseDataset: (@dataset) ->

    getParties: ->
        partyIds_processed = []
        output = []
        @forEachParty (party) ->
            return if party.id in partyIds_processed
            {id, name, abbr, votes_sum, votes_sum_percent} = party
            output.push {id, name, abbr, votes_sum, votes_sum_percent}
            partyIds_processed.push id
        output

    getCandidates: ->
        output = @loadCandidates!
        @sortCandidates output
        output

    loadCandidates: ->
        output = []
        @forEachParty ({candidates}:party) ->
            candidates.forEach (candidate) ->
                {partyId, name, surname, mandate} = candidate
                return if not mandate
                output.push {partyId, name, surname}
        output

    sortCandidates: (candidates) ->
        candidates.sort (a, b) ->
            | a.partyId - b.partyId => that
            | a.votedRank - b.votedRank => that
            | otherwise => a.rank - b.rank

    forEachParty: (fn) ->
        @dataset.forEach ({parties}:county) ->
            parties.forEach fn
