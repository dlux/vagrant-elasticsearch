#!/bin/bash

echo "Destroying the environment."

vagrant destroy -f
rm -rf .vagrant
vagrant up
