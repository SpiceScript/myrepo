# Create a WinPE Boot Disk with BitLocker Support

## Preparation
Before you begin, ensure you have installed the Windows Assessment and Deployment Kit (ADK) and the WinPE add-on. You can download them from the official Microsoft website.

## Steps to Create the WinPE Boot Disk

```sh
# 1. Run Deployment and Imaging Tools Environment as Administrator
# Open the Deployment and Imaging Tools Environment as an administrator.
Deployment and Imaging Tools Environment

# 2. Create the WinPE Image Working Directory
# Run the following command to create the WinPE working directory:
copype amd64 C:\WinPE_amd64
# Note: Adjust the `copype` command according to your architecture if necessary.

# 3. Mount the WinPE Image for Modification
# Mount the WinPE image to modify it:
dism /Mount-Image /ImageFile:C:\WinPE_amd64\media\sources\boot.wim /index:1 /MountDir:C:\WinPE_amd64\mount

# 4. Create a BitLocker Subdirectory in the Mounted Image
# Create a directory for BitLocker:
mkdir C:\WinPE_amd64\mount\Windows\System32\BitLocker

# 5. Copy "manage-bde.exe" and Its Language Files
# Copy the BitLocker management executable and its language files:
copy C:\Windows\System32\manage-bde.exe C:\WinPE_amd64\mount\Windows\System32\BitLocker\
xcopy C:\Windows\System32\en-US C:\WinPE_amd64\mount\Windows\System32\BitLocker\en-US /s /e

# 6. Install the Necessary Packages
# Install the required packages:
Dism /Image:"C:\WinPE_amd64\mount" /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-NetFx.cab"
Dism /Image:"C:\WinPE_amd64\mount" /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-PowerShell.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-WMI.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-SecureStartup.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-EnhancedStorage.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\WinPE-Scripting.cab"

# 7. Install the Corresponding Language Packages
# Install the language packages:
Dism /Image:"C:\WinPE_amd64\mount" /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-NetFx_en-us.cab"
Dism /Image:"C:\WinPE_amd64\mount" /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-PowerShell_en-us.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-WMI_en-us.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-SecureStartup_en-us.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-EnhancedStorage_en-us.cab"
dism /Image:C:\WinPE_amd64\mount /Add-Package /PackagePath:"C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64\WinPE_OCs\en-us\WinPE-Scripting_en-us.cab"

# 8. Copy Automation Files
# Copy your automation scripts:
copy "C:\CS\DeleteCrowdStrikeFile.ps1" "C:\WinPE_amd64\mount"
copy "C:\CS\RunScript.bat" "C:\WinPE_amd64\mount"
copy "C:\CS\startnet.cmd" C:\WinPE_amd64\mount\Windows\System32

# 9. Unmount the Image and Save Changes
# Unmount the image and commit changes:
dism /Unmount-Image /MountDir:"C:\WinPE_amd64\mount" /Commit

# 10. Create the WinPE Boot Disk with the Modified Image
# Create the bootable ISO:
oscdimg -m -o -u2 -udfver102 -bootdata:2#p0,e,bC:\WinPE_amd64\fwfiles\etfsboot.com#pEF,e,bC:\WinPE_amd64\fwfiles\efisys.bin C:\WinPE_amd64\media C:\cs\WinPEv15.iso
