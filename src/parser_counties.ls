module.exports.parse = (xml) ->
    xml["VYSLEDKY_KRAJMESTA"]["KRAJ"].map (kraj) ->
        name    = kraj.$.NAZ_KRAJ
        id      = +kraj.$.CIS_KRAJ
        votes   = +kraj.CELKEM[0].UCAST[0].$.PLATNE_HLASY
        parties = kraj.CELKEM[0].HLASY_STRANA.map (strana) ->
            id    = +strana.$.KSTRANA
            votes = +strana.$.HLASY
            {id, votes}

        {id, name, votes, parties}


