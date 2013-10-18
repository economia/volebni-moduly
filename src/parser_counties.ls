module.exports.parse = (xml) ->
    root = xml["VYSLEDKY_KRAJMESTA"] || xml["VYSLEDKY"]
    root["KRAJ"].map (kraj) ->
        name    = kraj.$.NAZ_KRAJ
        id      = +kraj.$.CIS_KRAJ
        if kraj.CELKEM
            parties = getPartiesFromKrajmesta that
            ucast   = kraj.CELKEM[0].UCAST[0].$
        else
            parties = getPartiesFromMain kraj
            ucast   = kraj.UCAST[0].$
        votes = +ucast.PLATNE_HLASY

        attendance_max    = +ucast.ZAPSANI_VOLICI
        attendance_actual = +ucast.VYDANE_OBALKY
        processed_target  = +ucast.OKRSKY_CELKEM
        processed_actual  = +ucast.OKRSKY_ZPRAC

        {id, name, votes, attendance_max, attendance_actual, processed_target, processed_actual, parties}


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
