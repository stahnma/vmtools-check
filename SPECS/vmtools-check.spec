Name:           vmtools-check
Version:        20100208
Release:        1%{?dist}
Summary:        Simple utility to verify the VMwareTools setup

Group:          System Environment/Daemons
License:        WTFPL
URL:            http://github.com/stahnma/vmtools-check
Source0:        vmtools-check-%{version}.tar.gz
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       ruby >= 1.8.1
BuildRequires:  ruby-rdoc
BuildArch:      noarch
Requires(post): chkconfig
Requires(preun):chkconfig
Requires(preun):initscripts

%description
Autoupdater for VMwareTools package for RHEL clients 

%prep
%setup -q

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/{init.d,rc3.d,rc5.d}
mkdir -p $RPM_BUILD_ROOT%{_libexecdir}/%{name}
rdoc vmtools-check.rb
install -p -m755 vmtools-check.sh $RPM_BUILD_ROOT%{_sysconfdir}/rc.d/init.d/%{name}
install -p -m755 network-reload  $RPM_BUILD_ROOT%{_libexecdir}/%{name}
install -p -m755 vmtools-check.rb  $RPM_BUILD_ROOT%{_libexecdir}/%{name}/

%post
# This adds the proper /etc/rc*.d links for the script
/sbin/chkconfig --add %{name}

%preun
if [ $1 = 0 ] ; then
    /sbin/service %{name} stop >/dev/null 2>&1
    /sbin/chkconfig --del %{name}
fi

%clean
rm -rf $RPM_BUILD_ROOT

%files
%defattr(-,root,root,-)
%doc doc README
%{_sysconfdir}/rc.d/init.d/%{name}
%{_libexecdir}/%{name}

%changelog
* Mon Feb 08 2010 <stahnma@websages.com> - 20100208-1
- Updated with several fixes
- Now uses real initscripts 
- Provides decent init-style output

* Thu Feb 04 2010 <stahnma@websages.com> - 0.0-1
- Initial Package
