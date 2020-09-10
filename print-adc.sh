#!/bin/sh

if [ -z $1 ]
then
        echo usage: watch-adc channel
        exit
fi

readchannelinv()
{
	# the adc reports in microvolts
        uv=`sysctl -n dev.ads111x.0.$1.voltage`
        dc -e "4 k $uv 1000000 / p"
}

readchannelinv $1
