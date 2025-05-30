# 🔐 PowerShell Wi-Fi Password & Security Dashboard

A powerful PowerShell script that scans saved Wi-Fi profiles on a Windows machine, retrieves passwords, and generates an elegant, auto-refreshing HTML dashboard with QR codes, anomaly detection, and device MAC data.

## ✨ Features

* 🔍 Extract previously connected Wi-Fi profiles and passwords
* 📊 Generates a beautiful HTML dashboard report
* 🔐 AI-based anomaly scoring (simulated behavior model)
* 🛁 MAC address retrieval of devices sharing Wi-Fi
* 📷 QR Code generation for Wi-Fi credentials (scan & connect)
* ⏱ Auto-refreshing web interface (every 15 seconds)
* 💾 Export to CSV
* ✅ Lightweight, no external dependencies required

## ⚙️ Usage

> ⚠️ Must be run as **Administrator**

```powershell
.\wifi-dashboard.ps1
```

Optional Parameters:

* `-csvOnly` → Only export CSV, no HTML dashboard
* `-reportTo "C:\Reports"` → Custom export directory
* `-noPause` → Don't wait for user input at the end

## 📁 Output

* `wifi_passwords_*.csv`: Saved Wi-Fi credentials
* `wifi_passwords_*.html`: Interactive report

## 🔐 Example Dashboard

 ![Image Alt](https://github.com/tajulislamsaidul/Connected-wifi-Details/blob/7096cbfc91b57cc21cbcc3d1f2fab3524e7768a2/DEMO.png)

## 🧠 AI & Security Insights

* Anomaly scoring based on device MAC behavior
* Highlights "Unknown" MACs as high risk
* Great for detecting unauthorized connections

---

## 🛠️ Requirements

* Windows 10/11
* PowerShell 5.1+

---


## 🙌 Contribution

Feel free to submit PRs, suggestions, or open issues!

---
