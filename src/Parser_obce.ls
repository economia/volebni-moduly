require! {
    events.EventEmitter
}
kraje_to_nuts =
    1: \CZ010
    2: \CZ020
    3: \CZ031
    4: \CZ032
    5: \CZ041
    6: \CZ042
    7: \CZ051
    8: \CZ052
    9: \CZ053
    10: \CZ063
    11: \CZ064
    12: \CZ064
    13: \CZ072
    14: \CZ080
module.exports = class Parser extends EventEmitter
    (parties) ->
        @parties_assoc = {}
        for party in parties
            @parties_assoc[party.id] = party

    parse: (xml) ->
        @parseOkres xml.VYSLEDKY_OKRES.OKRES.0
        xml.VYSLEDKY_OKRES.OBEC.forEach ~>
            @parseObec it

    parseVysledkyToKraje: (xml) ->
        xml.VYSLEDKY.KRAJ.forEach (kraj) ~>
            id = kraje_to_nuts[kraj.$.CIS_KRAJ]
            content = @parseKraj kraj
            @emit \item id, content

    parseOkres: (okres) ->
        id = okres.$.CIS_OKRES
        content = @parseUnit okres
        @emit \item id, content

    parseObec: (obec) ->
        id = obec.$.CIS_OBEC
        content = @parseUnit obec
        @emit \item id, content

    parseKraj: (unit) ->
        UCAST = unit.UCAST.0.$
        attendance_max    = +UCAST.ZAPSANI_VOLICI
        attendance_actual = +UCAST.VYDANE_OBALKY
        processed_target  = +UCAST.OKRSKY_CELKEM
        processed_actual  = +UCAST.OKRSKY_ZPRAC
        parties = unit.STRANA.map (strana) ~>
            party = @parties_assoc[strana.$.KSTRANA]
            partyResult = strana.HODNOTY_STRANA.0.$
            partyOut = {} <<< party
                ..votes_sum = +partyResult.HLASY
                ..votes_sum_percent = +partyResult.PROC_HLASU / 100
        {attendance_max, attendance_actual, processed_target, processed_actual, parties}

    parseUnit: (unit) ->
        UCAST = unit.UCAST.0.$
        attendance_max    = +UCAST.ZAPSANI_VOLICI
        attendance_actual = +UCAST.VYDANE_OBALKY
        processed_target  = +UCAST.OKRSKY_CELKEM
        processed_actual  = +UCAST.OKRSKY_ZPRAC
        parties           = @getParties unit
        {attendance_max, attendance_actual, processed_target, processed_actual, parties}

    getParties: (root) ->
        return [] if not root.HLASY_STRANA
        root.HLASY_STRANA.map ({$:partyResult}) ~>
            party = @parties_assoc[partyResult.KSTRANA]
            partyOut = {} <<< party
                ..votes_sum = +partyResult.HLASY
                ..votes_sum_percent = +partyResult.PROC_HLASU / 100





