#!/bin/bash

set +e

read -p "Are you sure you want to destroy environment and files - y/n?  " yn
[[ -n $(echo $yn | grep -i "^n") ]] && echo "Clean up canceled." && exit 0

echo "Destroying the environment."

echo -e  'y\n y\n' | vagrant destroy
rm -r shared_*
rm -r .vagrant
rm -r .keys
rm authorized_keys
rm ubuntu*
