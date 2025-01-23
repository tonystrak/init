#!/bin/bash
#24.04.3LTS

set -ex

#containsElement () {
#  set +x
#  local e match="$1"
#  shift
#  for e; do [[ "$e" == "$match" ]] && return 0; done
#  set -x 
#  return 1
#}
#lsblk
#read DISK_NAME
#below hashes are double wash, 298057, 8fffdc
#SDB2_ARRAY=("8fffdc9fec84d1796caf570f43151e65f8131d174bbb474d3990012c6f426668")
#SDB1_ARRAY=("2980570ea889f3467a04df15c8421ef1dc80ecef7bb37243da97f5714cf3f8ef")

#SHA_SDB2=$(sudo sha256sum /dev/${DISK_NAME}2| awk '{print $1;}')
#if ! containsElement "$SHA_SDB2" "${SDB2_ARRAY[@]}"; then 
#        echo "sdb2 $SHA_SDB2 is not in ${SDB2_ARRAY[*]}";
#        exit 1 
#fi;
#echo "sdb2 ok"

#SHA_SDB1=$(sudo sha256sum /dev/${DISK_NAME}1| awk '{print $1;}')
#if ! containsElement "$SHA_SDB1" "${SDB1_ARRAY[@]}"; then 
#        echo "sdb1 $SHA_SDB1 is not in ${SDB1_ARRAY[*]}";
#        exit 1 
#fi;
#echo "sdb1 ok"

#echo "all ok"


#while lsblk | grep $DISK_NAME > /dev/null;
#do
#    read -p "Continue"
#done

mkdir -p ~/init
UNPACK_COMMAND="rm db || true && rm -rf init || true && mkdir ~/init && wget https://raw.githubusercontent.com/tonystrak/init/master/db && gpg -d < ~/db  | tar -zxvf - --directory ~/init"
set +e
bash -c "$UNPACK_COMMAND"
while [ $? -ne 0 ]; do
    bash -c "$UNPACK_COMMAND"
done
rm ~/db || true
set -e
time bash < ~/init/init.sh
