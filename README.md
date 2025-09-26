# Android Device Bulk Customization Script

A powerful **Bash automation script** designed to apply system-wide customizations to multiple Android devices simultaneously via **ADB (Android Debug Bridge)**.  
Ideal for **kiosk environments**, **digital signage**, **demo setups**, or **enterprise configurations**.

---

## 🚀 Features

- 🔄 **Batch Execution**: Configure multiple Android devices in one run  
- ⏰ **Automatic TR Timezone Setup**: Sets system time and timezone to **Europe/Istanbul**  
- 🔒 **Lock Screen Disabled**: Removes screen lock, swipe, and ads  
- 💡 **Max Screen Brightness**: Ensures maximum display brightness  
- ⚡ **No Sleep Mode**: Prevents device from entering idle or sleep state  
- 📶 **Wi-Fi & Bluetooth Disabled**: Enhances security and stability  
- 🖼️ **Wallpaper Management**: Automatically sets both **home** and **lock screen** wallpapers  
- 🔁 **Auto Reboot**: Restarts devices after configuration  
- 🧾 **Logging**: Every action is logged with timestamps for traceability  

---

## 🧠 Requirements

- **ADB (Android Debug Bridge)** installed and available in your system `PATH`
- **Root access** enabled on each target Android device  
- Devices must be **accessible over the same network** via `adb connect`
- Optional: a **wallpaper.png** file in the same directory (to set a custom wallpaper)

---

## ⚙️ Configuration

Open the script file (`change.sh`) and edit the following line to include your device IPs:

```bash
DEVICE_IPS="192.168.109.150|192.168.109.151|192.168.109.152|192.168.109.153"
````

> 📌 Devices should be separated by the pipe symbol (`|`).

---

## 🧩 Usage

Run the script in your terminal:

```bash
sh change.sh
```

The script will:

1. Connect to each device via `adb`
2. Gain root access
3. Apply all configurations (time, brightness, lock screen, etc.)
4. Push wallpaper (if available)
5. Reboot the device

---

## 📁 Log Output

All operations are logged to a file with a timestamp:

```
device_config_YYYYMMDD_HHMMSS.log
```

You can review logs to verify success or troubleshoot connection issues.

---

## 🖼️ Wallpaper Setup (Optional)

To set a custom wallpaper:

1. Place your image in the same directory as the script
2. Name it exactly `wallpaper.png`

If no file is found, the script will skip this step gracefully.

---

## 🧰 Example Output

```
[192.168.109.150] Starting configuration...
[192.168.109.150] Timezone and date set: 092609352025.10
[192.168.109.150] Lock screen and ads disabled.
[192.168.109.150] Screen brightness set to maximum.
[192.168.109.150] Wi-Fi disabled.
[192.168.109.150] Bluetooth disabled.
[192.168.109.150] Wallpaper applied.
[192.168.109.150] Rebooting...
```

---

## 🛠️ Troubleshooting

* **Device not found**:
  Ensure the device is connected and accessible via IP. Test with:

  ```bash
  adb connect <IP_ADDRESS>
  ```

* **Permission denied**:
  Confirm the device has **root permissions** and **ADB debugging** enabled.

* **Wallpaper not applied**:
  Make sure the file `wallpaper.png` exists and has correct permissions.

---

## 🔒 Security Notes

* Only use on **trusted networks**
* Do not include unknown IP addresses
* Ensure devices are **company-owned** and **rooted intentionally**

---

## 🧠 Tip

To run automatically on startup, you can create a **systemd service** or schedule it via **cron** for maintenance routines.

Would you like to see a ready-made `systemd` unit file example? 👇
*(If yes, I can generate `change.service` for you.)*

---

## 📜 License

This project is licensed under the [MIT License](LICENSE). See the license file for details.

---

## 🙌 Issues, Feature Requests or Support

Please use the Issue > New Issue button to submit issues, feature requests or support issues directly to me. You can also send an e-mail to akin.bicer@outlook.com.tr.
