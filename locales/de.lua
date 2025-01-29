local Translations = {
    success = {
        success_message = "Erfolgreich",
        fuses_are_blown = "Die Sicherungen sind durchgebrannt",
        door_has_opened = "Die Tür ist geöffnet"
    },
    error = {
        cancel_message = "Abgebrochen",
        safe_too_strong = "Es sieht so aus, als ob das Safe-Verschluss zu stark ist...",
        missing_item = "Es fehlt ein Gegenstand...",
        bank_already_open = "Die Bank ist bereits geöffnet...",
        minimum_police_required = "Mindestens %{police} Polizisten erforderlich",
        security_lock_active = "Das Sicherheitsvorhängeschloss ist aktiv, die Tür kann momentan nicht geöffnet werden",
        wrong_type = "%{receiver} hat den falschen Typ für das Argument '%{argument}' erhalten\nerhaltener Typ: %{receivedType}\n erhaltene Wert: %{receivedValue}\nerwarteter Typ: %{expected}",
        fuses_already_blown = "Die Sicherungen sind bereits durchgebrannt...",
        event_trigger_wrong = "%{event}%{extraInfo} wurde ausgelöst, als einige Bedingungen nicht erfüllt waren, Quelle: %{source}",
        missing_ignition_source = "Es fehlt eine Zündquelle"
    },
    general = {
        breaking_open_safe = "Das Safe aufbrechen...",
        connecting_hacking_device = "Das Hacking-Gerät anschließen...",
        fleeca_robbery_alert = "Fleeca-Banküberfallversuch",
        paleto_robbery_alert = "Blain County Savings Bank Überfallversuch",
        pacific_robbery_alert = "Pacific Standard Bank Überfallversuch",
        break_safe_open_option_target = "Safe aufbrechen",
        break_safe_open_option_drawtext = "[E] Safe aufbrechen",
        validating_bankcard = "Karte wird überprüft...",
        thermite_detonating_in_seconds = "Thermit zündet in %{time} Sekunde(n)",
        bank_robbery_police_call = "10-90: Banküberfall"
    }
}

if GetConvar('qb_locale', 'en') == 'de' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true,
        fallbackLang = Lang,
    })
end
