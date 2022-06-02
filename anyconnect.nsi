/*

Anyconnect Umbrella SWG Single File Installer NSIS Script
Version: 1.2
Author: thomngo
Release Notes: Added DART Module
License: Apache License 2.0
Deploys:
    Anyconnect Core VPN - anyconnect-win-X.X.XXXXX-core-vpn-predeploy-k9.msi
    Anyconnect Umbrella Roaming Security Module - anyconnect-win-X.X.XXXXX-umbrella-predeploy-k9.msi
    Anyconnect DART Module - anyconnect-win-X.X.XXXXX-dart-predeploy-k9.msi
    Umbrella Root CA - Cisco_Umbrella_Root_CA.cer
    Umbrella Module Profile - OrgInfo.json

Usage:
1. Download the Module Profile and the latest Umbrella Root CA file from dashboard.umbrella.com
2. Download and extract the Anyconnect Windows Pre-Deployment files from software.cisco.com
3. Update the version string at Line 25 to versions desired (specified by X.X.XXXXX in the file name)
4. Compile the installer using the provided NSI file with the four above files in the same directory
5. Deploy the installer as required

*/

; Define the version
!define VERSION "4.10.05095"

; Name dependencies, LogicLib for If loop
!include LogicLib.nsh

;  Name the installer
Name "Anyconnect ${VERSION} Installer"

; Output file to write
OutFile "Anyconnect ${VERSION}.exe"

; Build Unicode Installer
Unicode True

; Specify silent install
SilentInstall silent

; Request application privileges for Windows Vista and up
RequestExecutionLevel Admin

; Install Anyconnect Core VPN
Section "Core VPN"
  File "anyconnect-win-${VERSION}-core-vpn-predeploy-k9.msi"
  ExecWait 'msiexec /package "$INSTDIR\anyconnect-win-${VERSION}-core-vpn-predeploy-k9.msi" /qn PRE_DEPLOY_DISABLE_VPN=1 /lvx* vpninstall.log '
SectionEnd

; Install Anyconnect Umbrella Roaming Security Module
Section "Umbrella"
  File "anyconnect-win-${VERSION}-umbrella-predeploy-k9.msi"
  ExecWait 'msiexec /package "$INSTDIR\anyconnect-win-${VERSION}-umbrella-predeploy-k9.msi" /qn PRE_DEPLOY_DISABLE_VPN=1 /lvx* umbrellainstall.log'
SectionEnd

; Install Anyconnect DART Module
Section "Umbrella"
  File "anyconnect-win-${VERSION}-dart-predeploy-k9.msi"
  ExecWait 'msiexec /package "$INSTDIR\anyconnect-win-${VERSION}-dart-predeploy-k9.msi" /qn /lvx* dartinstall.log'
SectionEnd

; Copy OrgInfo.json to appropriate directory
Section "OrgInfo.json"
  File OrgInfo.json
  SetShellVarContext all
  CopyFiles "$INSTDIR\OrgInfo.json" "$LOCALAPPDATA\Cisco\Cisco AnyConnect Secure Mobility Client\Umbrella\OrgInfo.json"
SectionEnd

; Define function to add to Certificate Store
!define CERT_QUERY_OBJECT_FILE 1
!define CERT_QUERY_CONTENT_FLAG_ALL 16382
!define CERT_QUERY_FORMAT_FLAG_ALL 14
!define CERT_STORE_PROV_SYSTEM 10
!define CERT_STORE_OPEN_EXISTING_FLAG 0x4000
!define CERT_SYSTEM_STORE_LOCAL_MACHINE 0x20000
!define CERT_STORE_ADD_ALWAYS 4
 
Function AddCertificateToStore
 
  Exch $0
  Push $1
  Push $R0
 
  System::Call "crypt32::CryptQueryObject(i ${CERT_QUERY_OBJECT_FILE}, w r0, \
    i ${CERT_QUERY_CONTENT_FLAG_ALL}, i ${CERT_QUERY_FORMAT_FLAG_ALL}, \
    i 0, i 0, i 0, i 0, i 0, i 0, *i .r0) i .R0"
 
  ${If} $R0 <> 0
 
    System::Call "crypt32::CertOpenStore(i ${CERT_STORE_PROV_SYSTEM}, i 0, i 0, \
      i ${CERT_STORE_OPEN_EXISTING_FLAG}|${CERT_SYSTEM_STORE_LOCAL_MACHINE}, \
      w 'ROOT') i .r1"
 
    ${If} $1 <> 0
 
      System::Call "crypt32::CertAddCertificateContextToStore(i r1, i r0, \
        i ${CERT_STORE_ADD_ALWAYS}, i 0) i .R0"
      System::Call "crypt32::CertFreeCertificateContext(i r0)"
 
      ${If} $R0 = 0
 
        StrCpy $0 "Unable to add certificate to certificate store"
 
      ${Else}
 
        StrCpy $0 "success"
 
      ${EndIf}
 
      System::Call "crypt32::CertCloseStore(i r1, i 0)"
 
    ${Else}
 
      System::Call "crypt32::CertFreeCertificateContext(i r0)"
 
      StrCpy $0 "Unable to open certificate store"
 
    ${EndIf}
 
  ${Else}
 
    StrCpy $0 "Unable to open certificate file"
 
  ${EndIf}
 
  Pop $R0
  Pop $1
  Exch $0
 
FunctionEnd

; Install the Root CA into Trusted Root Certificate Authorities
Section "Umbrella Root CA"
  File Cisco_Umbrella_Root_CA.cer
  Push "$INSTDIR\Cisco_Umbrella_Root_CA.cer"
  Call AddCertificateToStore
  Pop $0
  ${If} $0 != success
    MessageBox MB_OK "import failed: $0"
  ${EndIf}
SectionEnd

; Install Root CA into Firefox if exists
Section "Firefox Umbrella Root CA"
; Specify 64 Bit Windows
SetRegView 64
; Check if Firefox is installed
ReadRegStr $0 HKLM "SOFTWARE\Mozilla\Mozilla Firefox" "CurrentVersion"
; If key is not empty, Firefox is installed
${If} $0 != ""
  SetShellVarContext current
  CopyFiles "$INSTDIR\Cisco_Umbrella_Root_CA.cer" "$LOCALAPPDATA\Mozilla\Certificates\Cisco_Umbrella_Root_CA.cer"
  WriteRegDword HKLM "SOFTWARE\Policies\Mozilla\Firefox\Certificates" "ImportEnterpriseRoots" 0x00000001
${EndIf}
SectionEnd

; Clean Up Installer Files
Section "Clean Up"
  Delete "$INSTDIR\anyconnect-win-${VERSION}-core-vpn-predeploy-k9.msi"
  Delete "$INSTDIR\anyconnect-win-${VERSION}-umbrella-predeploy-k9.msi"
  Delete "$INSTDIR\anyconnect-win-${VERSION}-dart-predeploy-k9.msi"
  Delete "$INSTDIR\OrgInfo.json"
  Delete "$INSTDIR\Cisco_Umbrella_Root_CA.cer"
SectionEnd
