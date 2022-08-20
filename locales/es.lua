local Translations = {
    success = {
        success_message = "Exitoso",
        fuses_are_blown = "Los fusibles se han quemado",
        door_has_opened = "la puerta se ha abierto"
    },
    error = {
        cancel_message = "Cancelado",
        safe_too_strong = "Parece que la cerradura de la caja fuerte es demasiado fuerte...",
        missing_item = "Te falta un artículo...",
        bank_already_open = "El banco ya está abierto....",
        minimum_police_required = "Mínimo de % {policía} policía requerida",
        security_lock_active = "El bloqueo de seguridad está activo, actualmente no es posible abrir la puerta",
        wrong_type = "%{receptor} no recibió el tipo correcto para el argumento '%{argumento}'\n tipo recibido: %{tiporecibido}\n valor recibido: %{receivedValue}\n tipo esperado: %{esperado}",
        fuses_already_blown = "los fusibles ya estan quemados...",
        event_trigger_wrong = "%{event}%{extraInfo} se activó cuando no se cumplieron algunas condiciones, fuente: %{source}",
        missing_ignition_source = "You're missing an ignition source"
    },
    general = {
        breaking_open_safe = "Rompiendo la caja fuerte abierta...",
        connecting_hacking_device = "Conexión del dispositivo de piratería...",
        fleeca_robbery_alert = "Intento de atraco a un banco de Fleeca",
        paleto_robbery_alert = "Intento de robo del banco de ahorros del condado de Blain",
        pacific_robbery_alert = "Intento de robo del banco Pacific Standard",
        break_safe_open_option_target = "Rompe la caja fuerte abierta",
        break_safe_open_option_drawtext = "[E] Rompe la caja fuerte",
        validating_bankcard = "Tarjeta de validación...",
        thermite_detonating_in_seconds = "Termita se está apagando en %{tiempo} segundos(s)",
        bank_robbery_police_call = "10-90: Robo de un banco"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
