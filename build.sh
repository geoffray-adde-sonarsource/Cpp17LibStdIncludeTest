#!/bin/bash
BW_PATH=/home/geoffray/bin/build-wrapper-linux-x86/build-wrapper-linux-x86-64
SS_PATH=/home/geoffray/bin/sonar-scanner-4.2.0.1873-linux/bin/sonar-scanner
rm -rf build
mkdir build
cd build
cmake ..
cd ..
${BW_PATH} --out-dir bw_output cmake --build build
${SS_PATH}

