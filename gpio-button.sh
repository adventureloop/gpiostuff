#!/bin/sh

set -e

if [ -z $1 ] || [ -z $2 ]
then
        echo "usage: gpio-button.sh GPIOBUS GPIOPIN"
	echo "  i.e: gpio-button.sh 0 11"
        exit
fi

gpiobus=$1
gpio=$2
delay=0.1	# read button 10 times a second

readbutton()
{
	gpioctl -f /dev/gpioc$1 $2
}

gpioctl -f /dev/gpioc$gpiobus -c $gpio IN PU

while true; do
        status=`readbutton $gpiobus $gpio`
	if [ $status == "0" ]
	then
        	printf "\r Button Pressed    \r"
	else
        	printf "\r Button Not Pressed\r"
	fi
        sleep $delay
done
