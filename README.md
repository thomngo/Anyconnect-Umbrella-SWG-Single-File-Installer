#  Anyconnect Umbrella SWG Single File Installer 
NSIS Script to build a single silent EXE Installer for Anyconnect Umbrella SWG

**Version: 1.2**

Release Notes: Added DART Module

## Tested Environment
- Windows 10 21H1 (64 Bit)
- Umbrella Root Certificate deployed in Mozilla Firefox Certificate Store v100.0 and Certificate Manager's Trusted Root Certificate Authorities

***

This script creates an silent installer which installs and deploys:
- Anyconnect Core VPN - anyconnect-win-X.X.XXXXX-core-vpn-predeploy-k9.msi
- Anyconnect Umbrella Roaming Security Module - anyconnect-win-X.X.XXXXX-umbrella-predeploy-k9.msi
- Anyconnect DART Module - anyconnect-win-X.X.XXXXX-dart-predeploy-k9.msi
- Umbrella Root CA - Cisco_Umbrella_Root_CA.cer
- Umbrella Module Profile - OrgInfo.json

## Prerequisites
- NSIS 3.08 https://nsis.sourceforge.io/Download

## Usage
1. Download the Module Profile and the latest Umbrella Root CA file from dashboard.umbrella.com
2. Download and extract the Anyconnect Windows Pre-Deployment files from software.cisco.com
3. Download the NSI file and edit the file to deploy the version desired (specified by X.X.XXXXX in the file name)
4. Compile the installer using the provided NSI file with the above files in the same directory
5. Deploy the installer as required

**Youtube Tutorial** (2 minutes): https://www.youtube.com/watch?v=SYov_Hmbe6U
