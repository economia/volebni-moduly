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

