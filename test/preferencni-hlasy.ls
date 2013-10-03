require! {
    expect : "expect.js"
    prefhlasy: "../lib/preferencni-hlasy"
}
test = it
class Candidate
    (@name, @preferentialVotes) ->

describe "Preferencni hlasy" ->
    # Olomoucky kraj, 2010 - vykrouzkovani Langera
    # http://www.volby.cz/pls/ps2010/ps111?xjazyk=CZ&xkraj=12&xstrana=26&xv=1&xt=2
    mandates = 2
    candidatesIn =
        new Candidate "Langer Ivan" 3114
        new Candidate "Fiala Radim" 4980
        new Candidate "Boháč Zdeněk" 5509
        new Candidate "Krill Petr" 3731
        new Candidate "Žmolík Lubomír" 3905
        new Candidate "Orság Stanislav" 3361
        new Candidate "Rudolfová Pavla" 2827
        new Candidate "Riedlová Zdeňka" 2946
        new Candidate "Grambličková Elena" 1877
        new Candidate "Králíková Barbora" 2418
        new Candidate "Brnčal Roman" 2294
        new Candidate "Olbertová Pavla" 1434
        new Candidate "Hemerková Ivana" 2817
        new Candidate "Darek Roman" 1132
        new Candidate "Tesař Jan" 2493
        new Candidate "Mareš Ivo" 2805
        new Candidate "Ťulpík Josef" 1421
        new Candidate "Bouchal Leon" 1779
        new Candidate "Švec Jan" 2279
        new Candidate "Oulehla Miloslav" 3044
        new Candidate "Pijáčková Eva" 4318
        new Candidate "Dvorský Miloslav" 3315

    candidatesOut =
        "Boháč Zdeněk"
        "Fiala Radim"
        "Pijáčková Eva"
        "Žmolík Lubomír"
        "Krill Petr"
        "Orság Stanislav"
        "Dvorský Miloslav"
        "Langer Ivan"
        "Oulehla Miloslav"
        "Riedlová Zdeňka"
        "Rudolfová Pavla"
        "Hemerková Ivana"
        "Mareš Ivo"
        "Grambličková Elena"
        "Králíková Barbora"
        "Brnčal Roman"
        "Olbertová Pavla"
        "Darek Roman"
        "Tesař Jan"
        "Ťulpík Josef"
        "Bouchal Leon"
        "Švec Jan"

    test "should compute test case correctly" ->
        results = prefhlasy.compute do
            *   candidatesIn
            *   54769
            *   voteAccessor: -> it.preferentialVotes
                threshold: 0.05
        results.forEach (candidate, index) ->
            expect candidate.name .to.equal candidatesOut[index]

    test "should work with result accessors" -> # zero-based
        results = prefhlasy.compute do
            *   candidatesIn
            *   54769
            *   voteAccessor: -> it.preferentialVotes
                threshold: 0.05
                resultProperty: \poradi
        results.forEach (candidate, index) ->
            expect candidate.name .to.equal candidatesOut[index]
            expect candidate.poradi .to.equal index



