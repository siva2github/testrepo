testip=`/usr/bin/az vm show -d -g DevOpstestgroup -n testvm --query publicIps -o tsv`
FILE="/etc/ansible/hosts"
if grep -q "$testip" "$FILE" ; then
        echo 'exist' ;
else
        echo $testip >> /etc/ansible/hosts ;
fi