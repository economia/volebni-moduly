require! {
    mandaty: "../src/mandaty-po-kraji"
    "../src/dhondt"
}
module.exports.combine = (counties, parties, candidates) ->
    counties_assoc = {}
    parties_assoc = {}
    counties.forEach -> counties_assoc[it.id] = it
    parties.forEach -> parties_assoc[it.id] = it
    county_party_candidates_assoc = {}
    computePartyTotals counties, parties_assoc
    counties.forEach (county) ->
        decorator = -> decorateParty it, parties_assoc
        county.parties.forEach decorator
        county.parties.forEach (party) ->
            county_party_candidates_assoc["#{county.id}-#{party.id}"] = party.candidates = []
    candidates.forEach (candidate) ->
        county_party_candidates_assoc["#{candidate.countyId}-#{candidate.partyId}"].push candidate

    counties

module.exports.compute = (counties) ->
    mandaty.compute do
        *   counties
        *   200
        *   countAccessor: -> it.votes
            resultProperty: \mandates

    counties.forEach (county) ->
        dhondt.compute do
            *   county.parties
            *   county.mandates
            *   voteAccessor: -> it.votes
                resultProperty: \mandates

computePartyTotals = (counties, parties_assoc) ->
    counties.forEach (county) ->
        county.parties.forEach (party) ->
            return if not party.votes
            globalParty = parties_assoc[party.id]
            globalParty.votes_sum = (globalParty.votes_sum || 0) + party.votes

decorateParty = (party, parties_assoc) ->
    for property, value of parties_assoc[party.id]
        party[property] = value
