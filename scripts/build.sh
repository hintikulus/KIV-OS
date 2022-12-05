#!/bin/bash

rm ../src/sources/build -R -f
rm ../src/sources/userspace/build -R -f

cd ../src/sources
./build.sh
cd userspace/
./build.sh
cd ..
./build.sh
cd ..
