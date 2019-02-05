#!/bin/bash

set -o xtrace

echo -e "\n\n---> Installing Pre-Requisites\n"
irepo='https://github.com/dlux/InstallScripts'
uri=https://artifacts.elastic.co/downloads

if [[ ! -f common_packages ]]; then
    curl -LO ${irepo}/raw/master/common_packages
    curl -LO ${irepo}/raw/master/common_functions
fi

source common_packages
EnsureRoot
UpdatePackageManager
$_INSTALLER_CMD vim git screen tree

echo -e "\n\n---> Installing JDK1.8\n"
yum install -y java-1.8.0-openjdk

echo -e "\n\n---> Installing elasticsearch\n"
InstallELKSElasticsearch
echo -e "\n\n---> Installing kibana\n"
InstallELKSKibana
echo 'KIBANA SERVED AT http://localhost:5601'
echo -e "\n\n---> Installing logstash\n"
InstallELKSLogstash

