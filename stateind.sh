#!/bin/bash
#
# status indicator
# Copyright (C) <2012>  Crs Chin<crs.chin@gmail.com>
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330,
# Boston, MA 02111-1307, USA.
#


__SLASH=("\b/" "\b-" "\b\\" "\b|")


__restore()
{
    setterm -cursor on
}

__inactive()
{
    if [ "$1" = SLASH ];then
        echo -en "\b"
    fi
    __restore
    exit
}

__active()
{
    IDX=0

    trap "__inactive $@" SIGUSR1
    trap "__restore" SIGINT
    trap "__restore" SIGHUP

    setterm -cursor off
    echo -n " "
    for ((;((1));))
    do
        if [ "$1" = "SLASH" ];then
            echo -en ${__SLASH[$((IDX%4))]}
            ((IDX++))
            sleep 0.1
        else
            echo -n .
            sleep 0.5
        fi
    done
}


__PID=0


state_inactive()
{
    if [[ $__PID != 0 ]];then
        kill -USR1 $__PID >  /dev/null 2>&1
        wait $__PID
    fi

    trap - SIGINT
    trap - SIGHUP
}


state_active()
{
    trap "state_inactive" SIGINT
    trap "state_inactive" SIGHUP

    __active $@ &
    __PID=$!
}


if [ "$1" = "--test" ];then
    state_active SLASH
    sleep 5
    state_inactive
    state_active
    sleep 5
    state_inactive
    echo Done
fi
