#/bin/bash

../../qemu/build/qemu-system-arm -machine raspi0 -serial null -serial mon:stdio -kernel ./../src/sources/build/kernel.img -nographic
