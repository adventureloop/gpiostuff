#!/bin/sh

set -e

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
then
        echo "usage: gpio-button.sh GPIOBUS LEDPIN BUTTONPIN"
	echo "  i.e: gpio-button.sh 0 25 24"
        exit
fi

gpiobus=$1
ledgpio=$2
buttongpio=$3
delay=0.1	# read button 10 times a second

readbutton()
{
	gpioctl -f /dev/gpioc$1 $2
}

gpioctl -f /dev/gpioc$gpiobus -c $ledgpio OUT
gpioctl -f /dev/gpioc$gpiobus -c $buttongpio IN PU

while true
do
        status=`readbutton $gpiobus $buttongpio`
	if [ $status == "0" ]
	then
        	printf "\r Button Pressed    \r"
    		gpioctl -f /dev/gpioc$gpiobus $ledgpio 1 > /dev/null
	else
        	printf "\r Button Not Pressed\r"
    		gpioctl -f /dev/gpioc$gpiobus $ledgpio 0 > /dev/null
	fi
        sleep $delay
done
