# Microsoft 365 Lizenzverwaltung via PowerShell

Diese Anleitung enthält alle PowerShell-Kommandos, um Microsoft 365 Benutzerlizenzen (z. B. `O365_BUSINESS_PREMIUM`) anzuzeigen, zu verwalten und gezielt zuzuweisen.

## Voraussetzungen

1. PowerShell 7 empfohlen (aber auch Windows PowerShell funktioniert).
2. Microsoft Graph PowerShell SDK:
```powershell
Install-Module Microsoft.Graph -Scope CurrentUser
```

## 1. Anmeldung

```powershell
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All" -UseDeviceAuthentication
```

## 2. Lizenzübersicht anzeigen (insbesondere O365 Business Premium)

```powershell
Get-MgSubscribedSku | Where-Object { $_.SkuPartNumber -eq "O365_BUSINESS_PREMIUM" } |
Select-Object SkuPartNumber, @{Name="Total";Expression={$_.PrepaidUnits.Enabled}}, ConsumedUnits, @{Name="Available";Expression={$_.PrepaidUnits.Enabled - $_.ConsumedUnits}}
```

## 3. Alle Benutzer mit Lizenz(en) anzeigen

```powershell
$users = Get-MgUser -All -Property DisplayName, UserPrincipalName, AssignedLicenses
$skus = Get-MgSubscribedSku

$users | Where-Object { $_.AssignedLicenses.Count -gt 0 } | ForEach-Object {
    $user = $_
    $skuNames = $user.AssignedLicenses.SkuId | ForEach-Object {
        $skuId = $_
        ($skus | Where-Object { $_.SkuId -eq $skuId }).SkuPartNumber
    }

    [PSCustomObject]@{
        DisplayName       = $user.DisplayName
        UserPrincipalName = $user.UserPrincipalName
        Licenses          = ($skuNames -join ", ")
    }
} | Format-Table -AutoSize
```

## 4. Benutzer mit bestimmter Lizenz auflisten (z. B. O365 Business Premium)

```powershell
$skuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"

$usersWithLicense = Get-MgUser -All -Property AssignedLicenses, DisplayName, UserPrincipalName | Where-Object {
    $_.AssignedLicenses | Where-Object { $_.SkuId -eq $skuId }
}

$usersWithLicense | Select DisplayName, UserPrincipalName

```

## 5. Lizenz einem Benutzer zuweisen

```powershell
Set-MgUserLicense -UserId "thomas.hillar@centraweb.de" `
  -AddLicenses @(@{SkuId = "f245ecc8-75af-4f8e-b61f-27d8114de5f3"}) `
  -RemoveLicenses @()
```

## 6. Lizenz von einem Benutzer entfernen

```powershell
Set-MgUserLicense -UserId "thomas.hillar@centraweb.de" `
  -RemoveLicenses @("f245ecc8-75af-4f8e-b61f-27d8114de5f3") `
  -AddLicenses @()
```

## 7. Lizenzdetails eines Benutzers prüfen

```powershell
Get-MgUserLicenseDetail -UserId "thomas.hillar@centraweb.de"
```

---

*Erstellt von Alexander Schönfeld – Stand: 2025-07-03*
