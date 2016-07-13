#!/usr/bin/env bash

image10_11="/Volumes/Raid5/VMs-Raid5/Based Image Building - 10.11.vmwarevm/Based Image Building - 10.11.vmx"
image10_10="/Volumes/Raid5/VMs-Raid5/Based Image Building - 10.10.vmwarevm/Based Image Building - 10.10.vmx"
image10_09="/Volumes/Raid5/VMs-Raid5/Based Image Building - 10.9.vmwarevm/Based Image Building - 10.9.vmx"
update_date=`date "+%Y.%m.%d"`

########
#Starting up VMs
########
echo "Starting VMs"
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start "$image10_11"
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start "$image10_10"
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion start "$image10_09"

sleep 150
echo "Getting IPs"
#Get IP addresses
image10_11ip=`/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion getGuestIPAddress "$image10_11"`
image10_10ip=`/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion getGuestIPAddress "$image10_10"`
image10_09ip=`/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion getGuestIPAddress "$image10_09"`

#########
#updating
#########
#Needs SSH keys installed before this would work
######
#Updating 10.11 image
######
echo "updating 10.11 image"
ssh -oStrictHostKeyChecking=no build@$image10_11ip /usr/sbin/softwareupdate -i -a
echo "Apple Update done 10.11"
ssh -oStrictHostKeyChecking=no build@$image10_11ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/cgerke-recipes.git
ssh -oStrictHostKeyChecking=no build@$image10_11ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/homebysix-recipes.git
ssh -oStrictHostKeyChecking=no build@$image10_11ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/timsutton-recipes.git
echo "Repos updated 10.11"
ssh -oStrictHostKeyChecking=no build@$image10_11ip /usr/local/bin/autopkg install AutoDMG.install
ssh -oStrictHostKeyChecking=no build@$image10_11ip /usr/local/bin/autopkg install AutoCasperNBI.install

######
#Updating 10.10 image
######
echo "Updating 10.10 image"
ssh -oStrictHostKeyChecking=no build@$image10_10ip /usr/sbin/softwareupdate -i -a
echo "Apple Update done 10.10"
ssh -oStrictHostKeyChecking=no build@$image10_10ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/cgerke-recipes.git
ssh -oStrictHostKeyChecking=no build@$image10_10ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/homebysix-recipes.git
ssh -oStrictHostKeyChecking=no build@$image10_10ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/timsutton-recipes.git
echo "Repos updated 10.10"
ssh -oStrictHostKeyChecking=no build@$image10_10ip /usr/local/bin/autopkg install AutoDMG.install
ssh -oStrictHostKeyChecking=no build@$image10_10ip /usr/local/bin/autopkg install AutoCasperNBI.install

######
#Updating 10.9 image
######
echo "Updating 10.9 image"
ssh -oStrictHostKeyChecking=no build@$image10_09ip /usr/sbin/softwareupdate -i -a
echo "Apple Update done 10.9"
ssh -oStrictHostKeyChecking=no build@$image10_09ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/cgerke-recipes.git
ssh -oStrictHostKeyChecking=no build@$image10_09ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/homebysix-recipes.git
ssh -oStrictHostKeyChecking=no build@$image10_09ip /usr/local/bin/autopkg repo-update https://github.com/autopkg/timsutton-recipes.git
echo "Repos updated 10.9"
ssh -oStrictHostKeyChecking=no build@$image10_09ip /usr/local/bin/autopkg install AutoDMG.install
ssh -oStrictHostKeyChecking=no build@$image10_09ip /usr/local/bin/autopkg install AutoCasperNBI.install


#Power down for snapshot
echo "powering down VMs"
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion stop "$image10_11" soft
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion stop "$image10_10" soft
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion stop "$image10_09" soft

sleep 30

#Take snapshot after updated
echo "Taking snapshots"
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion snapshot "$image10_11" Update-$update_date
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion snapshot "$image10_10" Update-$update_date
/Applications/VMware\ Fusion.app/Contents/Library/vmrun -T fusion snapshot "$image10_09" Update-$update_date
echo "done with snapshots"
exit 0
