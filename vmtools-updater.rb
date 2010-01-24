#!/usr/bin/env ruby

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

#does the vmtools-status file exist
if [ -f "/var/lib/vmtools-status" ] ; then
  kernel=`uname -r`
  filekernel=`grep KERNEL /var/lib/vmtools-status | awk -F= '{print $NF}'`
fi
