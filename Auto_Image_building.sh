#!/usr/bin/env bash

image10_11="/Volumes/Raid5/VMs/10.11 Base Image Building.vmwarevm/10.11 Base Image Building.vmx"
image10_10="/Volumes/Raid5/VMs/10.10 Base Image Building.vmwarevm/10.10 Base Image Building.vmx"
update_date=`date "+%Y.%m.%d"`


###########
#Starting up VMs
###########
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start "$image10_11"
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start "$image10_10"

sleep 200

#Get IP addresses
image10_11ip=`/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion getGuestIPAddress "$image10_11"`
image10_10ip=`/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion getGuestIPAddress "$image10_10"`

#Get latest snapshot
image10_11LatestSnap=`/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion listSnapshots "$image10_11" | tail -n 1`
image10_10LatestSnap=`/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion listSnapshots "$image10_10" | tail -n 1`

###########
#10.11 image Building
###########

currentOSXelCAP=`ls "/Volumes/MacDev/0All/Mac OS X Installers/10.11 - El Capitan Installers" | tail -n 1`
sourceInstallerElCap=`echo "/Volumes/MacDev/0All/Mac OS X Installers/10.11 - El Capitan Installers/"$currentOSXelCAP"/Install OS X El Capitan.app"`
scp -r -oStrictHostKeyChecking=no "$sourceInstallerElCap" brockma9@$image10_11ip:/Applications/
scp -r -oStrictHostKeyChecking=no "/Volumes/MacDev/brockma9-Kyle_Brockman/AutoDMG_scripts/Auto-AutoDMG_OSX_Build-ElCapiton.sh" brockma9@$image10_11ip:
ssh -oStrictHostKeyChecking=no brockma9@$image10_11ip './Auto-AutoDMG_OSX_Build-ElCapiton.sh'

###########
#10.10 image Building
###########

currentOSXyosemite=`ls "/Volumes/MacDev/0All/Mac OS X Installers/10.10 - Yosemite Installers" | tail -n 1`
sourceInstallerYosemite=`echo "/Volumes/MacDev/0All/Mac OS X Installers/10.10 - Yosemite Installers/"$currentOSXyosemite"/Install OS X Yosemite.app"`
scp -r -oStrictHostKeyChecking=no "$sourceInstallerYosemite" brockma9@$image10_10ip:/Applications/
scp -r -oStrictHostKeyChecking=no "/Volumes/MacDev/brockma9-Kyle_Brockman/AutoDMG_scripts/Auto-AutoDMG_OSX_Build-Yosemite.sh" brockma9@$image10_10ip:
ssh -oStrictHostKeyChecking=no brockma9@$image10_10ip './Auto-AutoDMG_OSX_Build-Yosemite.sh'

sleep 10

#Power down for snapshot
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion stop "$image10_11" soft
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion stop "$image10_10" soft

sleep 60

/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion revertToSnapshot "$image10_11" $image10_11LatestSnap
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion revertToSnapshot "$image10_10" $image10_10LatestSnap

exit 0
