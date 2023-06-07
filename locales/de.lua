local Translations = {
    success = {
        success_message = "Erfolgreich",
        fuses_are_blown = "Die Sicherungen sind durchgebrannt",
        door_has_opened = "Die Tür hat sich geöffnet"
    },
    error = {
        cancel_message = "Abgebrochen",
        safe_too_strong = "Sieht aus, als wäre das Schloss des Safes zu stark...",
        missing_item = "Dir fehlt ein Item...",
        bank_already_open = "Die Bank ist bereits geöffnet...",
        minimum_police_required = "Mindestens %{police} Polizisten erforderlich",
        security_lock_active = "Die Sicherheitsverriegelung ist aktiv, das Öffnen der Tür ist derzeit nicht möglich",
        wrong_type = "%{receiver} hat nicht den richtigen Typ für das Argument '%{argument}' erhalten\nErhaltener Typ: %{receivedType}\nErhaltener Wert: %{receivedValue}\n Erwarteter Typ: %{expected}",
        fuses_already_blown = "Die Sicherungen sind bereits durchgebrannt...",
        event_trigger_wrong = "%{event}%{extraInfo} wurde ausgelöst, als einige Bedingungen nicht erfüllt waren. Quelle: %{source}",
        missing_ignition_source = "Dir fehlt eine Zündquelle"
    },
    general = {
        breaking_open_safe = "Breche den Safe auf...",
        connecting_hacking_device = "Schließe das Hacking-Gerät an...",
        fleeca_robbery_alert = "Versuchter Banküberfall auf die Fleeca Bank",
        paleto_robbery_alert = "Versuchter Banküberfall auf die Blain County Savings Bank",
        pacific_robbery_alert = "Versuchter Banküberfall auf die Pacific Standard Bank",
        break_safe_open_option_target = "Safe aufbrechen",
        break_safe_open_option_drawtext = "[E] Den Safe aufbrechen",
        validating_bankcard = "Validiere Karte...",
        thermite_detonating_in_seconds = "Thermit wird in %{time} Sekunde(n) explodieren",
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
