testip=`/usr/bin/az vm show -d -g DevOpstestgroup -n testvm --query publicIps -o tsv`

/usr/bin/az vm show -d -g DevOpstestgroup -n testvm --query publicIps -o tsv >> /etc/ansible/hosts

sshpass -p Password@123 ssh-copy-id azureuser@$testip> /dev/null