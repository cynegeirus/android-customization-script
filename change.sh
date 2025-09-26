#!/bin/bash

DEVICE_IPS="192.168.109.150|192.168.109.151|192.168.109.152|192.168.109.153|192.168.109.154|192.168.109.155|192.168.109.156|192.168.109.157|192.168.109.158|192.168.109.160|192.168.109.161|192.168.109.162|192.168.109.170|192.168.109.171|192.168.109.172|192.168.109.180|192.168.109.181|192.168.109.182|192.168.109.190|192.168.109.191|192.168.109.192|192.168.109.200|192.168.109.201|192.168.109.202|192.168.109.210|192.168.109.211"

LOG_FILE="device_config_$(date +%Y%m%d_%H%M%S).log"
WALLPAPER_FILE="wallpaper.png"

log() { echo "$(date +'%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }

get_tr_time_for_android() {
    local tr_time_raw
    tr_time_raw=$(TZ="Europe/Istanbul" date +"%Y-%m-%d %H:%M:%S")
    local MM DD hh mm YYYY SS
    YYYY=${tr_time_raw:0:4}
    MM=${tr_time_raw:5:2}
    DD=${tr_time_raw:8:2}
    hh=${tr_time_raw:11:2}
    mm=${tr_time_raw:14:2}
    SS=${tr_time_raw:17:2}
    echo "$MM$DD$hh$mm$YYYY.$SS"
}

setup_device() {
    local IP=$1
    local TR_DATE=$2
    local TARGET="$IP:5555"
    log "[$IP] Starting configuration..."
    adb connect "$IP" &>/dev/null
    sleep 1
    if ! adb devices | grep -q "$TARGET"; then
        log "[$IP] ERROR: Connection failed!"
        return 1
    fi
    adb -s "$TARGET" root &>/dev/null
    sleep 1

    adb -s "$TARGET" shell "setprop persist.sys.timezone Europe/Istanbul"
    adb -s "$TARGET" shell "toybox date $TR_DATE"
    adb -s "$TARGET" shell settings put global auto_time 0
    adb -s "$TARGET" shell settings put global auto_time_zone 0
    log "[$IP] Timezone and date set: $TR_DATE"

    adb -s "$TARGET" shell settings put global LOCKSCREEN_AD_ENABLED 0
    adb -s "$TARGET" shell settings put secure lock_screen_disabled 1
    adb -s "$TARGET" shell settings put secure lockscreen.disabled 1
    adb -s "$TARGET" shell settings put secure lock_screen_lock_after_timeout 0
    adb -s "$TARGET" shell settings put secure lockscreen.password_type 0
    adb -s "$TARGET" shell settings put secure lock_screen_type 0
    adb -s "$TARGET" shell settings put secure lockscreen.security_mode 0
    adb -s "$TARGET" shell locksettings clear
    adb -s "$TARGET" shell locksettings set-disabled true
    adb -s "$TARGET" shell wm dismiss-keyguard
    adb -s "$TARGET" shell am start -a android.intent.action.MAIN -c android.intent.category.HOME
    log "[$IP] Lock screen and ads disabled."

    adb -s "$TARGET" shell settings put system screen_brightness 255
    adb -s "$TARGET" shell settings put system screen_brightness_mode 0
    log "[$IP] Screen brightness set to maximum."

    adb -s "$TARGET" shell settings put global stay_on_while_plugged_in 3
    adb -s "$TARGET" shell settings put system screen_off_timeout 86400000
    adb -s "$TARGET" shell "dumpsys deviceidle disable"
    log "[$IP] Sleep mode disabled."

    adb -s "$TARGET" shell "svc wifi disable"
    log "[$IP] Wi-Fi disabled."

    adb -s "$TARGET" shell "svc bluetooth disable"
    adb -s "$TARGET" shell settings put global bluetooth_on 0
    log "[$IP] Bluetooth disabled."

    if [[ -f "$WALLPAPER_FILE" ]]; then
        adb -s "$TARGET" push "$WALLPAPER_FILE" /sdcard/wallpaper.png >/dev/null
        adb -s "$TARGET" shell "
            cp /sdcard/wallpaper.png /data/system/users/0/wallpaper
            cp /sdcard/wallpaper.png /data/system/users/0/wallpaper_orig
            cp /sdcard/wallpaper.png /data/system/users/0/wallpaper_lock
            cp /sdcard/wallpaper.png /data/system/users/0/wallpaper_lock_orig
            chown system:system /data/system/users/0/wallpaper*
            chmod 660 /data/system/users/0/wallpaper*
            killall com.android.systemui
        "
        log "[$IP] Wallpaper applied."
    else
        log "[$IP] WARNING: $WALLPAPER_FILE not found, skipping wallpaper setup."
    fi

    log "[$IP] Rebooting..."
    adb -s "$TARGET" reboot
}

TR_DATE=$(get_tr_time_for_android)

IFS='|' read -r -a IP_ARRAY <<< "$DEVICE_IPS"
for IP in "${IP_ARRAY[@]}"; do
    setup_device "$IP" "$TR_DATE"
done

log "All devices configured successfully: Timezone TR, no lock screen, ads disabled, Wi-Fi/Bluetooth off, brightness max, no sleep, wallpaper applied, rebooted."
