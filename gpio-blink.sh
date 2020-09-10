#!/bin/sh

if [ -z $1 ] || [ -z $2 ]
then
	echo "usage: gpio-blink.sh GPIOBUS GPIOPIN"
	echo "  i.e: gpio-blink.sh 0 10"
	exit
fi

gpiobus=$1
gpio=$2
delay=0.2

gpioctl -f /dev/gpioc$gpiobus -c $gpio OUT

while true
do  
    gpioctl -t -f /dev/gpioc$gpiobus $gpio
    sleep $delay
done
