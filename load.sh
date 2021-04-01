#!/bin/bash
set -ex
SHA1=$(sudo fdisk -l /dev/sdb | grep /dev/ | sha256sum)
SHA2=$(sudo sha256sum /dev/sdb2)
SHA3=$(sudo sha256sum /dev/sdb1)

SHA1a="7fb1f3cca9d2c1ecbd7c50ea34ab389433fe740101866165ac74918c6f01f511  -"
SHA2a="8fffdc9fec84d1796caf570f43151e65f8131d174bbb474d3990012c6f426668  /dev/sdb2"
SHA3a="93bdab204067321ff131f560879db46bee3b994bf24836bb78538640f689e58f  /dev/sdb1"


if [[ "$SHA1" != "$SHA1a" ]] || [[ "$SHA2" != "$SHA2a" ]] || [[ "$SHA3" != "$SHA3a" ]]; then
echo "hashes are not equal"
echo $SHA1
echo $SHA1a
echo $SHA2
echo $SHA2a
echo $SHA3
echo $SHA3a
exit 1
fi
echo "hashes are ok"

while lsblk | grep "sdb" > /dev/null;
do
    read -p "Continue"
done

mkdir -p ~/init
wget -qO- raw.githubusercontent.com/tonystrak/init/master/db | gpg -d  | tar -zxvf - --directory ~/init
time bash < ~/init/init.sh
