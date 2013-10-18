require! {
    events.EventEmitter
}
module.exports = class Parser extends EventEmitter
    (parties) ->
        @parties_assoc = {}
        for party in parties
            @parties_assoc[party.id] = party

    parse: (xml) ->
        @parseOkres xml.VYSLEDKY_OKRES.OKRES.0
        xml.VYSLEDKY_OKRES.OBEC.forEach ~>
            @parseObec it

    parseOkres: (okres) ->
        id = okres.$.CIS_OKRES
        content = @parseUnit okres
        @emit \item id, content

    parseObec: (obec) ->
        id = obec.$.CIS_OBEC
        content = @parseUnit obec
        @emit \item id, content

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





