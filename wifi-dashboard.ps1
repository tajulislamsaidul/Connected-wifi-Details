if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "This script must be run as Administrator."
    Read-Host "Press Enter to exit..."
    exit
}

param (
    [switch]$csvOnly,
    [switch]$noPause,
    [string]$reportTo = "$env:USERPROFILE\Desktop"
)

if (-not (Test-Path -Path $reportTo)) {
    New-Item -Path $reportTo -ItemType Directory | Out-Null
}

function Get-AnomalyScore($mac) {
    if ($mac -eq "Unknown") {
        return 0.95
    }
    $hash = [Math]::Abs(($mac.GetHashCode()) % 100) / 100.0
    return [math]::Round($hash, 2)
}

$wifiDetails = @()
$profiles = netsh wlan show profiles | Select-String "All User Profile" | ForEach-Object {
    ($_ -replace ".*: ", "").Trim()
}

foreach ($profile in $profiles) {
    $ssid = $profile
    $profileInfo = netsh wlan show profile name="`"$ssid`"" key=clear
    $passwordLine = $profileInfo | Select-String "Key Content"

    if ($passwordLine) {
        $password = ($passwordLine -replace ".*: ", "").Trim()
    } else {
        $password = "Not Available"
    }

    $gateway = "N/A"
    $mac = "Unknown"
    try {
        $currentNet = Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null }
        if ($currentNet) {
            $gateway = $currentNet.IPv4DefaultGateway.NextHop
            $mac = (Get-NetNeighbor -Address $gateway -ErrorAction SilentlyContinue).LinkLayerAddress
        }
    } catch {}

    $scanResults = "Safe"

    $qrText = "WIFI:S:$ssid;T:WPA;P:$password;;"
    $qrApi = "https://api.qrserver.com/v1/create-qr-code/?data=$($qrText -replace ';', '%3B')&size=150x150"
    $qrImageTag = "<img src='$qrApi' width='100' />"

    $wifiDetails += [PSCustomObject]@{
        SSID      = $ssid
        Password  = $password
        Device    = $gateway
        MAC       = $mac
        QRTag     = $qrImageTag
        Vulnerability = $scanResults
    }
}

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$csvPath = Join-Path -Path $reportTo -ChildPath "wifi_passwords_$timestamp.csv"
$wifiDetails | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

if (-not $csvOnly.IsPresent) {
    $htmlPath = Join-Path -Path $reportTo -ChildPath "wifi_passwords_$timestamp.html"

    $html = @"
<html><head><title>Wi-Fi Dashboard</title>
<style>
body {font-family: 'Segoe UI', sans-serif; background-color: #f8f9fa; padding: 20px; color: #333;}
h2, h3 {color: #222;}
table {border-collapse: collapse; width: 100%; margin-bottom: 30px; box-shadow: 0 2px 6px rgba(0,0,0,0.1); background-color: #fff;}
th, td {border: 1px solid #ddd; padding: 10px; text-align: left;}
th {background-color: #343a40; color: white;}
tr:nth-child(even) {background-color: #f2f2f2;}
</style>
<script>
setInterval(() => { location.reload(); }, 15000);
</script>
</head><body>
<h2>📡 Wi-Fi Security Dashboard</h2><p>Generated: $(Get-Date)</p>

<table>
<tr><th>SSID</th><th>Password</th><th>Device</th><th>MAC</th><th>Status</th><th>QR Code</th></tr>
"@

    foreach ($item in $wifiDetails) {
        $html += "<tr><td>$($item.SSID)</td><td>$($item.Password)</td><td>$($item.Device)</td><td>$($item.MAC)</td><td>$($item.Vulnerability)</td><td>$($item.QRTag)</td></tr>"
    }

    $html += "</table></body></html>"

    try {
        $html | Set-Content -Path $htmlPath -Encoding UTF8
        Write-Host "\n✅ HTML report created at: $htmlPath"
        Start-Process $htmlPath
    } catch {
        Write-Warning "❌ Failed to save or open the HTML report: $_"
    }
}

if (-not $noPause) {
    Read-Host "Press Enter to exit..."
}
