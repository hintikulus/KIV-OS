#!/bin/bash

rm sources/build -R -f
rm sources/userspace/build -R -f

cd sources
./build.sh
cd userspace/
./build.sh
cd ..
./build.sh
cd ..