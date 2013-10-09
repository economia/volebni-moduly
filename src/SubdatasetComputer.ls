module.exports = class SubdatasetComputer
    ->
    setBaseDataset: (@dataset) ->

    getParties: ->
        partyIds_processed = []
        output = []
        @dataset.forEach ({parties}:county) ->
            parties.forEach (party) ->
                return if party.id in partyIds_processed
                {id, name, abbr, votes_sum, votes_sum_percent} = party
                output.push {id, name, abbr, votes_sum, votes_sum_percent}
                partyIds_processed.push id
        output
