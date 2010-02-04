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


RED     =  "\033[0;31m"
GREEN   =  "\033[0;32m"
YELLOW  =  "\033[0;33m"
RESET   =  "\e[0m"  

def output(result )
   if result == 0 
     puts "\t\t\t\t\t[ #{GREEN}  OK #{RESET} ]"
   else result != 0
     puts "\t\t\t\t\t[ #{RED}   FAILED  #{RESET} ]"
   end
end

def warn(mesg)
     puts "\t\t\t\t\t[ #{YELLOW}   #{mesg}  #{RESET} ]"
end

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
    return true
  end
  return false
end

# Finds the latest version of VMwareTools RPM available in repos
# and compares that version with the currently installed version
def tools_current?()
  latest_available=`yum -y -d0 list VMwareTools  | tail -1 | awk '{print $2}'`.to_s.strip()
  current_version=`rpm -q VMwareTools | sed -e "s/VMwareTools-//g"  `.to_s.strip()
  print "Checking to see if VMwareTools are current"
  if (latest_available == current_version) 
     output(0)
     return true;
  end
  warn("Updating")
  return false;
end

# Run the actualy command to configure VMwareTools
def configure_tools()
  print "Configuring VMwareTools"
  system("/usr/bin/vmware-config-tools.pl --default &> /dev/null")
  output($?)
  load_network_module
end

def load_network_module
  %x{/etc/init.d/network stop; rmmod pcnet32;  rmmod vmxnet }
  %x{ modprobe vmxnet; /etc/init.d/network start } 
  output($?)
end

# Check to see if the VMwareTools are already configured for this kernel
def tools_configured?
  print "Verifying Configuration of VMwareTools"
  if File.exists?('/etc/vmware-tools/not_configured')
    warn "CONFIGURING"
    return false
  end
  output(0)
  return true
end

# Upgrade the VMwareTools 
def upgrade_tools
  print "Running upgrade VMwareTools"
  system("yum -q -y -d0 install VMwareTools")
  ouput($?)
end

if not is_vm?
  print "System is not a VMware Virtual Machine"
  output(0)
  exit 0
end
puts
if not  tools_installed? or not tools_current?
    upgrade_tools
end

if not tools_configured?
  configure_tools
end
