local Translations = {
    success = {
        success_message = "Ce l\'hai fatta!",
        fuses_are_blown = "I fusibili sono bruciati",
        door_has_opened = "La porta si è aperta"
    },
    error = {
        cancel_message = "Annullato",
        safe_too_strong = "Sembra che il blocco della cassaforte sia troppo duro...",
        missing_item = "Ti manca qualcosa...",
        bank_already_open = "La banca è già stata aperta...",
        minimum_police_required = "Minimo %{police} poliziotti richiesti",
        security_lock_active = "Il sistema di sicurezza è attivo, al momento non è possibile aprire la porta",
        wrong_type = "%{receiver} argomento non valido '%{argument}'\ntipo argomento: %{receivedType}\nvalore ricevuto: %{receivedValue}\nargomento previsto: %{expected}",
        fuses_already_blown = "I fusibili sono già bruciati...",
        event_trigger_wrong = "%{event}%{extraInfo} è stato triggerato quando alcune condizioni non sono corrette, source: %{source}",
        missing_ignition_source = "E come lo accendi?"
    },
    general = {
        breaking_open_safe = "Rompendo la cassaforte...",
        connecting_hacking_device = "Connessione del dispositivo...",
        fleeca_robbery_alert = "Tentativo di rapina alla Fleeca Bank",
        paleto_robbery_alert = "Tentativo di rapina alla Blain County Savings Bank",
        pacific_robbery_alert = "Tentativo di rapina alla Pacific Standard Bank",
        break_safe_open_option_target = "Rompi la cassaforte",
        break_safe_open_option_drawtext = "[E] Rompi la cassaforte",
        validating_bankcard = "Validazione carta...",
        thermite_detonating_in_seconds = "La termite brucerà tra %{time} secondi",
        bank_robbery_police_call = "10-90: Rapina in banca"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
