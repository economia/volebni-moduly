require! {
    expect : "expect.js"
    fs
    "../src/SubdatasetComputer"
}
test = it
describe "Subdataset Computer" ->
    subdatasetComputer = null
    baseDataset = null
    before (done) ->
        (err, data) <~ fs.readFile "#__dirname/data/sampleResult.json"
        baseDataset := JSON.parse data.toString!
        done!
    test "should initialize" ->
        subdatasetComputer := new SubdatasetComputer
        subdatasetComputer.setBaseDataset baseDataset

    test "should produce parties dataset" ->
        parties = subdatasetComputer.getParties!
        expect parties .to.be.an \array
        expect parties .to.have.length 26
        expect parties.0 .to.have.property \name "OBČANÉ.CZ"
        expect parties.0 .to.have.property \abbr "Občané"
        expect parties.0 .to.have.property \votes_sum 13397
        expect parties.0 .to.have.property \votes_sum_percent
        percent = Math.round parties.0.votes_sum_percent * 10000
        expect percent .to.equal 26

    test "should produce candidates dataset" ->
        candidates = subdatasetComputer.getCandidates!
        expect candidates .to.be.an \array
        expect candidates .to.have.length 200
        expect candidates.0 .to.have.property \name \Radek
        expect candidates.0 .to.have.property \surname \John
        expect candidates.0 .to.have.property \partyId 4
        expect candidates.0 .to.have.property \rank 1
        expect candidates.0 .to.have.property \votedRank 0
