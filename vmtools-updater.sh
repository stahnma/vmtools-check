#!/bin/bash

# check for a newer version of VMware-tools

# situations 
# there is an upgraded VMwareTools available
# we just isntalled a new kernel
# 
function is_vm()
{
  if ( /sbin/lspci | grep -i vmware &> /dev/null) ; then 
     return 0
  else 
     return 1
  fi 
}

#are we running in a vm?
#if ( /sbin/lspci | grep -i vmware &> /dev/null) ; then 
#  if [ -f "/var/lib/vmtools-status" ] ; then
#     # check the kernel version 
#     kernel=`uname -r`
#     filekernel=`grep KERNEL /var/lib/vmtools-status | awk -F= '{print $NF}'`
#  fi 
#fi 

if (is_vm); then
  echo "This is a vm"
fi
