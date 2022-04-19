local Translations = {
    progress = {
        -- client:plaeto
        breaking_safe = '正在破開保險箱..',
        connecting_hacking = '正在連結駭客裝置..',
        valid_card = '正在檢驗卡片..',
    },
    area = {
        paleto = '佩力托灣',
        pacific = 'Alta St',
    },
    bank ={
        small = 'Fleeca',
        paleto = 'Blaine County Savings',
        pacific = '太平洋標準銀行',
    },
    info = {
        -- client:powerstation
        is_going_off = '炸藥即將在 %{value} 後引爆..',
        -- server
        title = '銀行搶案',
        alertTitle = '%{Bank} 發生搶案',
        blipTitle = '10-90: 銀行搶案',
        break_safe = '破開保險箱',
    },
    success = {
        -- client:fleeca
        successful = '成功了!',
        -- client:powerstation
        fuss_broken = '引爆成功',
        door_is_open = '門已經打開了',
        -- client:pacific
        plz_valid = '請確認..',
    },
    error = {
        -- server
        missing_ignition = '缺少用來點火的東西',
        -- client:fleeca
        canceled = '取消了..',
        safe_lock_too_strong = '這個保險箱似乎非常的堅固..',
        missing_item = '身上沒有%{value}..',
        already_opened = '這銀行已經被搶過了..',
        required_cops = '最少需要 %{value} 名上班的警察才可以開搶..',
        security_locked = '安全鎖目前已啟動, 現在完全沒有將門打開的可能.',
        -- client:powerstation
        seems_blown = '似乎已經引爆過了.',
        -- client:pacific

    },
    callCops = {
        alarm_activated = '%{value} 銀行-%{value2}分行的警報被觸發(CAMERA ID: %{value3})',
    },
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})