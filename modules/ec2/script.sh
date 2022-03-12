#!/bin/bash -ex
echo -e "\e[31m----- change hostname --------------------------------------\e[m"
sed -i 's/^HOSTNAME=[a-zA-Z0-9\.\-]*$/HOSTNAME=TerraformPractice/g' /etc/sysconfig/network
hostname 'TerraformPractice'
hostname

echo -e "\e[31m----- change timezone ---------------------------------------\e[m"
cp /usr/share/zoneinfo/Japan /etc/localtime
sed -i 's|^ZONE=[a-zA-Z0-9\.\-\"]*$|ZONE="Asia/Tokyo”|g' /etc/sysconfig/clock
date

echo -e "\e[31m----- yum update --------------------------------------------\e[m"
yum update -y

echo -e "\e[31m----- end all -----------------------------------------------\e[m"
echo $?
