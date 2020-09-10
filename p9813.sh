#!/bin/sh

red=`echo $1 | cut -c-2 -`
green=`echo $1 | cut -c3-4 -`
blue=`echo $1 | cut -c5-6 -`
red=`printf "%d" 0x$red`
green=`printf "%d" 0x$green`
blue=`printf "%d" 0x$blue`

echo colours $red $green $blue

b7="$((($blue & 0x80) >> 2))"
b6="$((($blue & 0x40) >> 2))"
g7="$((($green & 0x80) >> 4))"
g6="$((($green & 0x40) >> 4))"
r7="$((($red & 0x80) >> 6))"
r6="$((($red & 0x40) >> 6))"

echo check bits $b7 $b6 $g7 $g6 $r7 $r6

cksum="$((0xC0 | !$b7 | !$b6 | !$g7 | !$g6 | !$r7 | !$r6))"

echo cksum $cksum

pattern="0 0 0 0 $cksum $blue $green $red 0 0 0 0"
echo $pattern

delay=0.001
datagpio='gpioc1 26'
clkgpio='gpioc1 27'

gpioctl -c -f /dev/$clkgpio OUT
gpioctl -c -f /dev/$datagpio OUT

set $pattern
for byte do # looping over the  elements of the $@ array ($1, $2...)
        #echo byte $byte

        for foo in `jot 8 7 0 -1`;
        do
                gpioctl -f /dev/$clkgpio 1
                sleep $delay
                gpioctl -f /dev/$clkgpio 0

                if [ "$(($byte & $((1<<$foo))))" -ne 0 ]; then
        #                echo -n 1;
                        gpioctl -f /dev/$datagpio 1
                else
        #                echo -n 0;
                        gpioctl -f /dev/$datagpio 0
                fi
                sleep $delay
        done
done
