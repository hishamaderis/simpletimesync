#!/bin/bash

# check if chronyd is installed
function checkntp {
echo "Checking if chronyd is installed..."
rpm -qa | grep chrony > /dev/null
if [ $? -ne 0 ]
then echo "Chrony is not installed, installing chrony..."; yum install chrony -y -q;
else echo "Chrony is installed, nothing to do";
fi
}

# adding ntp server to chrony.conf
function addntp {
grep -qE sirim\|unisza /etc/chrony.conf
if [ `echo $?` -ne 0 ]
then echo "Adding sirim and unisza time server...";
cat >> /etc/chrony.conf <<EOF
pool ntp1.sirim.my iburst
pool ntp2.sirim.my iburst
pool time.unisza.edu.my iburst
EOF
fi
}

checkntp
echo ""
addntp
echo ""

echo "Starting chronyd..."
systemctl restart chronyd
echo ""

echo "Forcing chronyc to sync..."
chronyc makestep
echo ""

echo "Starting and enabling chronyd on boot..."
systemctl enable chronyd; systemctl restart chronyd
echo ""

echo "Please check if time is synced by running 'chronyc sources'"
