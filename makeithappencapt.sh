#!/bin/bash

#
# Magical xrandr script to auto-generate resolutions
# for my 30" IPS monitor with the use of a Passive
# Dual-link mini-DP to DVI adapter
#

# It looks like the only one that works is 1400 900 51
# But even with that, it's a 16:9 resolution. So, the
# only usable one is 1280 800 60, which blows.

# Spawned Fri Feb  6 13:39:38 EST 2015
# ericjaw@gmail.com


declare -a DisplayRatio1619=(
    "1280 800"
    "1400 900 51"
    "1680 1050"
    "1920 1200"
    "2560 1600"
)
# Grabbed these from here:
# http://en.wikipedia.org/wiki/16:10

# Output connection from '/usr/bin/xrandr'
_DISPLAY="HDMI2"

# Refresh rates
declare -a HzRange=(
    "21"
    "22"
    "23"
    "24"
    "25"
    "30"
    "40"
    "50"
    "51"
    "52"
    "53"
    "54"
    "55"
    "56"
    "57"
    "58"
    "59"
)

function 60hz(){
    for (( i=0; i<${#DisplayRatio1619[@]}; i++ ))
    do
	echo "Adding ${DisplayRatio1619[$i]}..."
	#_cvt="$(cvt $i)"
	#_newmodeline="$(cvt ${DisplayRatio1619[$i]} | grep -oP "(?<=^Modeline ).*" | sed "s/\"//g")"
	# This apparently fails due to single quotes added in
	_newmodename="$(cvt ${DisplayRatio1619[$i]} | grep -oP "(?<=^Modeline ).*" | sed "s/\"//g" | grep -oP "^[a-zA-Z0-9_.]*")"
	#xrandr --newmode "$_newmodeline" || exit 1
	# This apparently fails due to single quotes added in
	xrandr --newmode $(cvt ${DisplayRatio1619[$i]} | grep -oP "(?<=^Modeline ).*" | sed "s/\"//g") || exit 1
	xrandr --addmode "$_DISPLAY" "$_newmodename" || exit 1

    done
}

function _test(){
    #_res="1920 1200"
    _res="1680 1050"
    #_res="1400 900"

    for (( i=0; i<${#HzRange[@]}; i++ ))
    do
	echo "Adding $_res ${HzRange[$i]}..."
	_newmodename="$(cvt $_res ${HzRange[$i]} | grep -oP "(?<=^Modeline ).*" | sed "s/\"//g" | grep -oP "^[a-zA-Z0-9_.]*")"
	xrandr --newmode $(cvt $_res ${HzRange[$i]} | grep -oP "(?<=^Modeline ).*" | sed "s/\"//g")
	xrandr --addmode "$_DISPLAY" "$_newmodename" || exit 1

    done
}

function areyousure(){
    echo "Are you sure you want to continue? (type \"yes\" to continue)"
    read _answer
    if [ "$_answer" == "yes" ]
    then
			60hz
    fi

    if [ "$_answer" == test ]
    then
        _test
    fi
}





# main

areyousure
