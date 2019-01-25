#!/bin/bash

curl -O https://raw.githubusercontent.com/dlux/InstallScripts/master/common_packages
curl -O https://raw.githubusercontent.com/dlux/InstallScripts/master/common_functions

source common_packages
UpdatePackageManager

$_INSTALLER_CMD vim git

git clone https://github.com/dlux/InstallScripts.git
 
