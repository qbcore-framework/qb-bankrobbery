local Translations = {
    error = {
        canceled = 'Afbrudt',
        too_strong = 'Det ser ud til at låsen er for kraftig...',
        missing_item = 'Du mangler en ting...',
        already_open = 'Ser ud til at banken allerede er åben...',
        minimum_cops = 'Minimum af %{minCops} politi er der brug for',
        security_lock = 'Sikkerhedslåsen er aktiv, det er i øjeblikket ikke muligt at åbne døren.',
        fuse_blowen = 'Det ser ud til, at sikringerne er sprunget.',
        missing_ignition = 'Du mangler en tændkilde',
    },
    success = {
        successful = 'Succes',
        fuse_broken = 'Sikringerne er gået i stykker',
        door_open = 'Døren er åben',
    },
    info = {
        rob_attempt = 'bank røveri startet',
        thermite_count = 'Thermite går af om %{time}..',
        alarm_at = 'Alarmen er blevet aktiveret ved %{bank} %{street} (kamera id: %{camid})',
    },
    text = {
        blip_name = '10-90: Bank Røveri',
        break_safe = '[E] Bryd boksne op',
    },
    progress = {
        breaking_safe = 'Åbner pengeskabet...',
        connect_device = 'Tilslutter hacking-enheden...',
        using_card_pacific = 'Validere kort...',
        using_card_paleto = 'Validere kort...',
    },
    banks = {
        fleeca = 'Fleeca',
        blaine = 'Blaine County Savings',
        pacific = 'Pacific Standard Bank',
    }
    target = {
        break_safe = 'Bryd boksne op'
    }
}

if GetConvar('qb_locale', 'en') == 'da' then
    Lang = Locale:new({
        phrases = Translations,
        warnOnMissing = true
    })    
end
