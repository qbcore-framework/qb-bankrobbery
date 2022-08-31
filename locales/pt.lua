local Translations = {
    success = {
        success_message = "Sucesso",
        fuses_are_blown = "Os fusíveis foram queimados",
        door_has_opened = "A porta abriu-se"
    },
    error = {
        cancel_message = "Cancelado",
        safe_too_strong = "Parece que a fechadura é demasiado forte...",
        missing_item = "Está-te a faltar um item...",
        bank_already_open = "O banco já está aberto...",
        minimum_police_required = "São precisos no minímo %{police} polícias",
        security_lock_active = "Fechadura de segurança foi ativada, não é possivel abrir a porta",
        wrong_type = "%{receiver} não recebeu o argumento certo '%{argument}'\ntipo de receptor: %{receivedType}\nvalor de receptor: %{receivedValue}\n tipo expectável: %{expected}",
        fuses_already_blown = "Os fusíveis ja foram queimados...",
        event_trigger_wrong = "%{event}%{extraInfo} foi desencadeada quando algumas condições não foram satisfeitas, fonte: %{source}",
        missing_ignition_source = "Está-te a faltar uma fonte de ignição"
    },
    general = {
        breaking_open_safe = "A arrombar o cofre...",
        connecting_hacking_device = "Conectando dispositivos de hacker...",
        fleeca_robbery_alert = "Tentativa de assalto ao banco Fleeca",
        paleto_robbery_alert = "Tentativa de assalto a uma caixa económica do Blain County",
        pacific_robbery_alert = "Tentativa de assalto ao banco Pacific Standard",
        break_safe_open_option_target = "Cofre aberto",
        break_safe_open_option_drawtext = "[E] Arrombar cofre",
        validating_bankcard = "A validar cartão...",
        thermite_detonating_in_seconds = "A thermite vai explodir em  %{time} segundo(s)",
        bank_robbery_police_call = "10-90: Assalto ao banco"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
