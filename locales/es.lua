local Translations = {
    success = {
        success_message = "Éxitoso",
        fuses_are_blown = "Los fusibles se han quemado",
        door_has_opened = "La puerta se ha abierto"
    },
    error = {
        cancel_message = "Cancelado",
        safe_too_strong = "Parece que el seguro de la caja fuerte es muy bueno...",
        missing_item = "Te está faltando un objeto...",
        bank_already_open = "El banco ya está abierto...",
        minimum_police_required = "Mínimo de %{police} policia requerido",
        security_lock_active = "El seguro está activo, no es posible abrir esta puerta",
        wrong_type = "%{receiver} no recibió el tipo correcto de argumento '%{argument}'\ntipo recibido: %{receivedType}\nvalor recibido: %{receivedValue}\n tipo esperado: %{expected}",
        fuses_already_blown = "Los fusibles ya están quemados...",
        event_trigger_wrong = "%{event}%{extraInfo} se activó cuando algunas condiciones no fueron cumplidas, fuente: %{source}",
        missing_ignition_source = "Te está faltando una fuente para encender"
    },
    general = {
        breaking_open_safe = "Rompiendo la caja fuerte...",
        connecting_hacking_device = "Conectando a dispositivo de hackeo...",
        fleeca_robbery_alert = "Intento de robo de Banco Fleeca",
        paleto_robbery_alert = "Intento de robo de Banco Blain County Savings",
        pacific_robbery_alert = "Intento de robo de Banco Pacific Standard",
        break_safe_open_option_target = "Abrir caja fuerte",
        break_safe_open_option_drawtext = "[E] Abrir caja fuerte",
        validating_bankcard = "Validando tarjeta...",
        thermite_detonating_in_seconds = "La termita explotara en %{time} segundo(s)",
        bank_robbery_police_call = "10-90: Robo de banco"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
