### Microsoft Graph PowerShell SDK – Installations- und Lizenzabfrageprozess

# 1. Installation des Microsoft Graph SDK (als Benutzer)

# Vorab: Prüfen, ob das Modul bereits installiert ist
Get-InstalledModule Microsoft.Graph -ErrorAction SilentlyContinue

# Falls nicht vorhanden, installieren:
Install-Module Microsoft.Graph -Scope CurrentUser -Force

# Falls das Repository als nicht vertrauenswürdig eingestuft wird:
# Bei der Abfrage "Möchten Sie die Module von 'PSGallery' wirklich installieren?" mit 'J' oder 'A' bestätigen


# 2. Verbindung mit Microsoft Graph aufbauen (inkl. MFA-Unterstützung)
Connect-MgGraph -Scopes "User.Read.All", "Directory.Read.All"

# Optional: Aktuell verbundenes Konto anzeigen
Get-MgContext


# 3. Übersicht über alle verfügbaren Lizenzpakete im Tenant
Get-MgSubscribedSku | Select SkuPartNumber, SkuId, ConsumedUnits, @{Name="TotalUnits";Expression={$_.PrepaidUnits.Enabled}}


# 4. Benutzer und Lizenzinformationen verstehen

## Get-MgUser
# Ruft allgemeine Informationen über Benutzerkonten im Tenant ab
# Enthält KEINE vollständigen Lizenzinformationen
Get-MgUser -All | Select DisplayName, UserPrincipalName

## Get-MgUserLicenseDetail
# Dieses Cmdlet benötigt IMMER einen UserId-Wert – entweder als GUID oder Benutzerobjekt-ID.
# Wird es ohne Parameter aufgerufen, erscheint die Eingabeaufforderung "Geben Sie Werte für die folgenden Parameter an".
# Beispiel:
# $user = Get-MgUser -UserId "max@firma.de"
# Get-MgUserLicenseDetail -UserId $user.Id
# Zeigt pro Benutzer die tatsächlich zugewiesenen Lizenzpakete (z. B. O365_BUSINESS_PREMIUM, FLOW_FREE)
# Am zuverlässigsten mit einer vollständigen Benutzersammlung:

# Alle Benutzer mit vollständiger ID laden
$users = Get-MgUser -All -Property Id, DisplayName, UserPrincipalName
$users | ForEach-Object {
    $user = $_
    $licenses = Get-MgUserLicenseDetail -UserId $user.Id
    foreach ($license in $licenses) {
        [PSCustomObject]@{
            DisplayName = $user.DisplayName
            UserPrincipalName = $user.UserPrincipalName
            LicenseObjectId = $license.Id
            SkuPartNumber = $license.SkuPartNumber
            SkuId = $license.SkuId
        }
    }
} | Sort-Object SkuPartNumber | Format-Table -AutoSize
# Beispiel:
# $user = Get-MgUser -UserId "max@firma.de"
# Get-MgUserLicenseDetail -UserId $user.Id

## Get-MgSubscribedSku
# Zeigt, welche Lizenzpakete im Tenant verfügbar sind, wie viele davon vergeben wurden und wie viele frei sind
# Gibt z. B. SkuPartNumber (Lizenzname) und SkuId (GUID) zurück
Get-MgSubscribedSku | Select SkuPartNumber, SkuId, ConsumedUnits, @{Name="TotalUnits";Expression={$_.PrepaidUnits.Enabled}}

## Unterschiede zusammengefasst:
# - Get-MgUser: Basisinformationen über Benutzer (Name, UPN, etc.)
# - Get-MgUserLicenseDetail: Pro Benutzer die zugewiesenen Lizenzen mit Klarnamen
# - Get-MgSubscribedSku: Übersicht über alle im Tenant vorhandenen Lizenztypen und deren Nutzung
