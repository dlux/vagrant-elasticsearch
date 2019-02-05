#!/bin/bash

set -o xtrace

irepo='https://github.com/dlux/InstallScripts'
if [[ ! -f common_packages ]]; then
    curl -LO ${irepo}/raw/master/common_packages
    curl -LO ${irepo}/raw/master/common_functions
fi

source common_packages
EnsureRoot
UpdatePackageManager
$_INSTALLER_CMD vim git screen tree

[[ ! -d InstallScripts ]] && git clone ${irepo}.git

# Install example application
# apache-mysql-php + booked app
pushd InstallScripts
./install_booked.sh
popd

# Install system beats
brepo="https://artifacts.elastic.co/downloads/beats"
curl -L -O $brepo/metricbeat/metricbeat-6.5.4-x86_64.rpm
sudo rpm -vi metricbeat-6.5.4-x86_64.rpm

