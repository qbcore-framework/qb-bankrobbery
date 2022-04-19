local Translations = {
    progress = {
        -- client:plaeto
        breaking_safe = 'Breaking open the safe..',
        connecting_hacking = 'Connecting the hacking device..',
        valid_card = 'Validitating card..',
    },
    area = {
        paleto = 'Paleto Bay',
        pacific = 'Alta St',
    },
    bank ={
        small = 'Fleeca',
        paleto = 'Blaine County Savings',
        pacific = 'Pacific Standard Bank',
    },
    info = {
        -- client:powerstation
        is_going_off = 'Thermite is going off in %{value} ..',
        -- server
        title = 'Bank robbery',
        alertTitle = '%{Bank} robbery attempt',
        blipTitle = '10-90: Bank Robbery',
        break_safe = 'Break Safe Open',
    },
    success = {
        -- client:fleeca
        successful = 'Successful!',
        -- client:powerstation
        fuss_broken = 'The fuses are broken',
        door_is_open = 'The door is open',
        -- client:pacific
        plz_valid = 'Please validate..',
    },
    error = {
        -- server
        missing_ignition = 'You\'re missing ignition source',
        -- client:fleeca
        canceled = 'Canceled..',
        safe_lock_too_strong = 'Looks like the safe lock is too strong..',
        missing_item = 'You\'re missing %{value}..',
        already_opened = 'Looks like the bank is already open..',
        required_cops = 'Minimum Of %{value} Police Needed..',
        security_locked = 'The security lock is active, opening the door is currently not possible.',
        -- client:powerstation
        seems_blown = 'It seems that the fuses have blown.',
        -- client:pacific

    },
    callCops = {
        alarm_activated = 'The Alarm of %{value} bank at %{value2} has been activated(CAMERA ID: %{value3})',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})