#!/bin/bash

npm list -g --depth=0 > global-packages.txt
dpkg --get-selections | grep -v deinstall > installed_packages.txt

