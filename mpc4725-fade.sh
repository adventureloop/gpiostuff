#!/bin/sh

iic="/dev/iic0"
address="0x62"

blink ()
{
	printf "\0\0" | i2c -f $1 -a $2 -d w -c 2 -m tr
	sleep 1
	printf "\17\377" | i2c -a 0x62 -d w -c 2 -m tr
	sleep 0.2
	printf "\0\0" | i2c -a 0x62 -d w -c 2 -m tr
	sleep 0.2
	printf "\17\377" | i2c -a 0x62 -d w -c 2 -m tr
	sleep 0.2
	printf "\0\0" | i2c -a 0x62 -d w -c 2 -m tr
	sleep 1
}

setlevel ()
{
	#printf "\r                                        "
	#printf "\r $(($1<< 4))\t `printf %o $level`"

	top=`printf "\\%o" $(((level & 0xF0 >> 4)))`
	bottom=`printf "\\%o" $(((level & 0x0F) << 4 ))`
	#printf "\rtop %o bottom %o     " $top $bottom

	printf "\rtop %o bottom %o     " $top $bottom
	#printf "\\$top\\$bottom" | hexdump -C
	#printf "\0\0" | i2c -a 0x62 -d w -c 2 -m tr
	
	printf "\\$top\\$bottom" | i2c -a 0x62 -d w -c 2 -m tr
}

#blink $iic $address

level=0
direction=-1
while true
do
	level=$((level+$direction))
	if [ $level -gt 255 ]
	then
		direction=-1
	fi
	if [ $level -le 0 ]
	then
		direction=1
	fi

	setlevel $level
	sleep 0.05
done
