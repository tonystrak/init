#!/bin/bash
#04.3L

set -ex

containsElement () {
  set +x
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  set -x 
  return 1
}

FDISK_ARRAY=("05f5a6e1a23af0a6a00d9cd4fbe5adc5b61bad52f7a03b41b5f69e5956330e99" "8a4572d8dbab496886494dff0124debebe54866d45d99f29009ce9d29ff113d0")
SDB2_ARRAY=("8fffdc9fec84d1796caf570f43151e65f8131d174bbb474d3990012c6f426668")
SDB1_ARRAY=( "5fdebc435ded46ae99136ca875afc6f05bde217be7dd018e1841924f71db46b5")

SHA_FDISK=$(sudo fdisk -l /dev/sdb | grep /dev/ | sha256sum |awk '{print $1;}' )
if ! containsElement "$SHA_FDISK" "${FDISK_ARRAY[@]}"; then 
	echo "fdisk $SHA_FDISK is not in ${FDISK_ARRAY[*]}";
	exit 1 
fi;
echo "fdisk ok"

SHA_SDB2=$(sudo sha256sum /dev/sdb2| awk '{print $1;}')
if ! containsElement "$SHA_SDB2" "${SDB2_ARRAY[@]}"; then 
        echo "sdb2 $SHA_SDB2 is not in ${SDB2_ARRAY[*]}";
        exit 1 
fi;
echo "sdb2 ok"

SHA_SDB1=$(sudo sha256sum /dev/sdb1| awk '{print $1;}')
if ! containsElement "$SHA_SDB1" "${SDB1_ARRAY[@]}"; then 
        echo "sdb1 $SHA_SDB1 is not in ${SDB1_ARRAY[*]}";
        exit 1 
fi;
echo "sdb1 ok"

echo "all ok"


while lsblk | grep "sdb" > /dev/null;
do
    read -p "Continue"
done

mkdir -p ~/init
UNPACK_COMMAND="wget -qO- raw.githubusercontent.com/tonystrak/init/master/db | gpg -d  | tar -zxvf - --directory ~/init"
set +e
bash -c "$UNPACK_COMMAND"
while [ $? -ne 0 ]; do
    bash -c "$UNPACK_COMMAND"
done
set -e
time bash < ~/init/init.sh
