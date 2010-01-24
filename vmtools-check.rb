#!/usr/bin/env ruby

def is_vm?()
  vm=`/sbin/lspci -v | grep -i vmware`
  if vm.size() > 0
    return true
  end
  return false
end

def tools_installed?()
  installed=`rpm -q VMwareTools`
  if $? == 0 
    puts "Version installed is #{installed}"
    return true
  end
  return false
# update file /var/lib/vmtools-check/status
end

def tools_current?()
  latest_available=`yum -y -d0 list VMwareTools  | tail -1 | awk '{print $2}'`.to_s.strip()
  current_version=`rpm -q VMwareTools | sed -e "s/VMwareTools-//g"  `.to_s.strip()
  puts "The latest available is #{latest_available}"
  puts "The current is #{current_version}"
  if (latest_available == current_version) 
     puts "You appear to have the latest version"
     return true;
  end
  return false;
end

def configure_tools()
  puts "Runing configure_tools"
  system("/usr/bin/vmware-config-tools.pl --default")
  puts "Configured tools, reboot to take effect"
end

def tools_configured?
  puts "Running tools_configured"
  if File.exists?('/etc/vmware-tools/not_configured')
    return false
  end
  return true
end

def upgrade_tools
  puts "Running upgrade_tools"
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
