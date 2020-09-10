#!/bin/sh

if [ -z $1 ]
then
        echo usage: watch-adc channel
        exit
fi

readtmp36()
{
	# the adc reports voltage in microvolts
	# see sysctl -d
        uv=`sysctl -n dev.ads111x.0.$1.voltage`
        # convert micro volts to milli volts
        mv=`dc -e "4 k $uv 1000 / p"`

        # convert millivolts to temperute, from adafruit:
        # Centigrade temperature = [(analo voltage in mV) - 500] / 10
        dc -e "2 k $mv 500 - 10 / p"
}

while true; do
        res=`readtmp36 $1`
        printf "\r                 "
        printf "\rTemperature: $res"
        sleep 1
done
