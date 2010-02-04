Name:           vmtools-check
Version:        0
Release:        1%{?dist}
Summary:        Simple utility to verify the VMwareTools setup

Group:          System Environment/Daemons
License:        WTFPL
URL:            http://github.com/stahnma/vmtools-check
Source0:        vmtools-check.rb
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)

Requires:       ruby >= 1.8.1
BuildRequires:  ruby-rdoc
BuildArch:      noarch

%description
Autoupdater for VMwareTools package for RHEL clients 

%prep
cp -f %{SOURCE0} . 


%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/{init.d,rc3.d,rc5.d}
rdoc vmtools-check.rb
install -p -m755 vmtools-check.rb $RPM_BUILD_ROOT%{_sysconfdir}/init.d/vmtools-check
pwd 
ls -l
cd $RPM_BUILD_ROOT%{_sysconfdir}/rc3.d; ln -s ../init.d/vmtools-check S18vmtools-check
pwd 
cd $RPM_BUILD_ROOT%{_sysconfdir}/rc5.d; ln -s ../init.d/vmtools-check S18vmtools-check
ls -l



%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%doc doc
%{_sysconfdir}/init.d/vmtools-check
%{_sysconfdir}/rc3.d/S18vmtools-check
%{_sysconfdir}/rc5.d/S18vmtools-check


%changelog
* Thu Feb 04 2010 <stahnma@fedoraproject.org> - 0.0-1
- Initial Package
