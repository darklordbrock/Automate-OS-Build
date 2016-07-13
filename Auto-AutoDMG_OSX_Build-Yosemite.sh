#!/bin/bash

/Applications/AutoDMG.app/Contents/MacOS/AutoDMG update

/Applications/AutoDMG.app/Contents/MacOS/AutoDMG -r build --download-updates /Volumes/VMware\ Shared\ Folders/MacDev/brockma9-Kyle_Brockman/AutoDMG_scripts/Auto-JAMF-autodmg-Yosemite.adtmpl

cp -f /Volumes/VMware\ Shared\ Folders/MacDev/0All/temp/All-Apple-OSX-10.10*.hfs.dmg /Volumes/VMware\ Shared\ Folders/MacDev/0All/0All-OS_X_ImageBuilds/All-0Current-10.10-OSX.hfs.dmg

mv /Volumes/VMware\ Shared\ Folders/MacDev/0All/temp/All-Apple-OSX-10.10*.hfs.dmg /Volumes/VMware\ Shared\ Folders/MacDev/0All/0All-OS_X_ImageBuilds/

exit 0
