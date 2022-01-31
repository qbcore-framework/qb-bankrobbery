local Translations = {
    error = {
        canceled = 'Canceled',
        too_strong = 'Looks like the safe lock is too strong ..',
        missing_item = 'You\'re missing an item ..',
        already_open = 'Looks like the bank is already open ..',
        minimum_cops = 'Minimum Of %{minCops} Police Needed',
        security_lock = 'The security lock is active, opening the door is currently not possible.',
        fuse_blowen = 'It seems that the fuses have blown.',
        missing_ignition = 'You\'re missing ignition source',

    },
    success = {
        successful = 'Successful',
        fuse_broken = 'The fuses are broken',
        door_open = 'The door is open',
    },
    info = {
        rob_attempt = 'bank robbery attempt',
        thermite_count = 'Thermite is going off in %{time}..',
        alarm_at = 'The Alram has been activated at %{bank} %{street} (CAMERA ID: %{camid})',
    },
    text = {
        blip_name = '10-90: Bank Robbery',
        break_safe = 'Break open the safe',
        crack_vault = 'Crack the vault',
    },
    progress = {
        breaking_safe = 'Breaking open the safe ..',
        connect_device = 'Connecting the hacking device ..',
        using_card_pacific = 'Please validate ..',
        using_card_paleto = 'Validitating card..',
    },
    banks = {
        fleeca = 'Fleeca',
        blaine = 'Blaine County Savings',
        pacific = 'Pacific Standard Bank',
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})
