#  Anyconnect Umbrella SWG Single File Installer 
NSIS Script to build a single silent EXE Installer for Anyconnect Umbrella SWG

Version: 1.1

Tested Environment
- Windows 10 21H1 (64 Bit)
- Umbrella Root Certificate deployed in Mozilla Firefox Certificate Store v100.0 and Certificate Manager's Trusted Root Certificate Authorities

Release Notes: Added support for Firefox

This script creates an silent installer which installs and deploys:
- Anyconnect Core VPN - anyconnect-win-X.X.XXXXX-core-vpn-predeploy-k9.msi
- Anyconnect Umbrella Roaming Security Module - anyconnect-win-X.X.XXXXX-umbrella-predeploy-k9.msi
- Umbrella Root CA - Cisco_Umbrella_Root_CA.cer
- Umbrella Module Profile - OrgInfo.json

Prerequisites:
- NSIS 3.08 https://nsis.sourceforge.io/Download

Usage:
1. Ensure the Root CA file is up to date
2. Ensure the Anyconnect packages are the versions desired
3. Update the version string in the NSI file to versions desired (specified by X.X.XXXXX in the file name)
4. Compile the installer using the provided NSI file with the four above files in the same directory
5. Deploy the installer as required

YouTube Tutorial: https://www.youtube.com/watch?v=SYov_Hmbe6U
