#!/usr/bin/env ruby
#
# Author:: Michael Stahnke (mailto:stahnma@websages.com)
# Copyright:: (c) 2010 Michael Stahnke
# License:: WTFPLv2
#
#
# Program designed to keep VMwareTools rpm updated on 
# RHEL VMware ESX(i) guests.
#
# Program requires
# * VMware guest be a RHEL/Centos version with Yum
# * yum-utils be installed
# * yum, rpm, awk, grep, tail, sed be in $PATH

# Determine if this script is running inside a vmware VM
def is_vm?()
  vm=`/sbin/lspci -v | grep -i vmware`
  if vm.size() > 0
    return true
  end
  return false
end

# Determines if the VMwareTools is currently installed
def tools_installed?()
  installed=`rpm -q VMwareTools`
  if $? == 0 
    #puts "Version installed is #{installed}"
    return true
  end
  return false
end

# Finds the latest version of VMwareTools RPM available in repos
# and compares that version with the currently installed version
def tools_current?()
  latest_available=`yum -y -d0 list VMwareTools  | tail -1 | awk '{print $2}'`.to_s.strip()
  current_version=`rpm -q VMwareTools | sed -e "s/VMwareTools-//g"  `.to_s.strip()
  puts "The latest available is #{latest_available}"
  puts "The current is #{current_version}"
  if (latest_available == current_version) 
     puts "VMwareTools version correct"
     return true;
  end
  return false;
end

# Run the actualy command to configure VMwareTools
def configure_tools()
  puts "Configuring VMwareTools"
  system("/usr/bin/vmware-config-tools.pl --default")
  puts "Configured tools, reboot to take effect"
end

# Check to see if the VMwareTools are already configured for this kernel
def tools_configured?
  puts "Verifying Configuration of VMwareTools"
  if File.exists?('/etc/vmware-tools/not_configured')
    return false
  end
  return true
end

# Upgrade the VMwareTools 
def upgrade_tools
  puts "Running upgrade VMwareTools"
  system("yum -y -d0 install VMwareTools")
end

if not is_vm?
  exit 0
end
if not  tools_installed? or not tools_current?
    upgrade_tools
end

if not tools_configured?
  configure_tools
end
