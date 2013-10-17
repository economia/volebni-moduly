module.exports.parse = (xml) ->
    root = xml["VYSLEDKY_KRAJMESTA"] || xml["VYSLEDKY"]
    root["KRAJ"].map (kraj) ->
        name    = kraj.$.NAZ_KRAJ
        id      = +kraj.$.CIS_KRAJ
        if kraj.CELKEM
            parties = getPartiesFromKrajmesta that
            votes   = +kraj.CELKEM[0].UCAST[0].$.PLATNE_HLASY
        else
            parties = getPartiesFromMain kraj
            votes   = +kraj.UCAST[0].$.PLATNE_HLASY

        {id, name, votes, parties}


getPartiesFromKrajmesta = (celkem) ->
    celkem[0].HLASY_STRANA.map (strana) ->
        id    = +strana.$.KSTRANA
        votes = +strana.$.HLASY
        {id, votes}


getPartiesFromMain = (kraj) ->
    kraj.STRANA.map (strana) ->
        id    = +strana.$.KSTRANA
        votes = +strana.HODNOTY_STRANA.0.$.HLASY
        {id, votes}
