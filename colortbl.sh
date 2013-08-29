#!/bin/bash
#
# Bash color table for xterm.
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
#/

# NOTE: this table work fine for XTERM, which is nearly used by all
# terminals under XWindows, some styles may not be supported under
# linux console, which is linux term, so this should content with our
# requirement for the most of the time.
# Have fun!
__STYLE_TABLE=(0 1 2 4 7 8 9);
__COLOR_TABLE=(0 1 2 3 4 5 6 7);

__TERMINAL=1;

__NORMAL=0;
__BOLD=1;
__DIM=2;
__UNDERLINE=3
__INVERT=4
__HIDE=5
__DELET=6

__GRAY=0;
__RED=1;
__GREEN=2;
__YELLOW=3;
__BLUE=4;
__VIOLET=5;
__CYAN=6;
__WHITE=7;


# exposed variables and functions
NORMAL=$__NORMAL;
BOLD=$__BOLD;
DIM=$__DIM;
UNDERLINE=$__UNDERLINE
INVERT=$__INVERT
HIDE=$__HIDE
DELET=$__DELET

# can specify only one tyle each time, but styles can overlap
# together, so to specify multiple styles, specify one color multiple
# times but with different styles, or use functions to print strings,
# remember to reset after finishing using veraiable styles
GRAY=("\033[0;30m" "\033[1;30m" "\033[2;30m" "\033[4;30m" "\033[7;30m" "\033[8;30m" "\033[9;30m");
RED=("\033[0;31m"  "\033[1;31m" "\033[2;31m" "\033[4;31m" "\033[7;31m" "\033[8;31m" "\033[9;31m");
GREEN=("\033[0;32m" "\033[1;32m" "\033[2;32m" "\033[4;32m" "\033[7;32m" "\033[8;32m" "\033[9;32m");
YELLOW=("\033[0;33m" "\033[1;33m" "\033[2;33m" "\033[4;33m" "\033[7;33m" "\033[8;33m" "\033[9;33m");
BLUE=("\033[0;34m" "\033[1;34m" "\033[2;34m" "\033[4;34m" "\033[7;34m" "\033[8;34m" "\033[9;34m");
VIOLET=("\033[0;35m" "\033[1;35m" "\033[2;35m" "\033[4;35m" "\033[7;35m" "\033[8;35m" "\033[9;35m");
CYAN=("\033[0;36m" "\033[1;36m" "\033[2;36m" "\033[4;36m" "\033[7;36m" "\033[8;36m" "\033[9;36m");
WHITE=("\033[0;37m" "\033[1;37m" "\033[2;37m" "\033[4;37m" "\033[7;37m" "\033[8;37m" "\033[9;37m");
RESET="\033[0;0m";

if [ ! -t 1 ];then
    __TERMINAL=0;

    GRAY=("");
    RED=("");
    GREEN=("");
    YELLOW=("");
    BLUE=("");
    VIOLET=("");
    CYAN=("");
    WHITE=("");
fi


F_CLRPRINT()
{
    __OPT="";
    if [ "$1" == "-n" ];then
        __OPT="-n";
        if [[ $# < 3 ]];then
            echo -e "${RED[$BOLD]}TOO FEW SPECIFIED$RESET";
            return;
        fi
        shift;
    else
        if [[ $# < 2 ]];then
            echo -e "${RED[$BOLD]}TOO FEW SPECIFIED$RESET";
            return;
        fi
    fi

    if [[ $TERMINAL == 0 ]];then
        echo $2;
        return;
    fi

    __COLOR="";
    case "$1" in
        GRAY)
            __COLOR="3${__COLOR_TABLE[$__GRAY]}m";
            ;;
        RED)
            __COLOR="3${__COLOR_TABLE[$__RED]}m";
            ;;
        GREEN)
            __COLOR="3${__COLOR_TABLE[$__GREEN]}m";
            ;;
        YELLOW)
            __COLOR="3${__COLOR_TABLE[$__YELLOW]}m";
            ;;
        BLUE)
            __COLOR="3${__COLOR_TABLE[$__BLUE]}m";
            ;;
        VIOLET)
            __COLOR="3${__COLOR_TABLE[$__VIOLET]}m";
            ;;
        CYAN)
            __COLOR="3${__COLOR_TABLE[$__CYAN]}m";
            ;;
        WHITE)
            __COLOR="3${__COLOR_TABLE[$__WHITE]}m";
            ;;
        *)
            echo -e "${RED[$BOLD]}BAD COLOR SPECIFIED:${i}$RESET";
            return;
    esac
    shift;

    __STRING=$1;
    shift;

    __STYLE="0;";
    while [ -n "$1" ];do
        case "$1" in
            NORMAL)
                __STYLE="${__STYLE}${__STYLE_TABLE[$__NORMAL]};";
                ;;
            BOLD)
                __STYLE="${__STYLE}${__STYLE_TABLE[$__BOLD]};";
                ;;
            DIM)
                __STYLE="${__STYLE}${__STYLE_TABLE[$__DIM]};";
                ;;
            UNDERLINE)
                __STYLE="${__STYLE}${__STYLE_TABLE[$__UNDERLINE]};";
                ;;
            INVERT)
                __STYLE="${__STYLE}${__STYLE_TABLE[$__INVERT]};";
                ;;
            HIDE)
                __STYLE="${__STYLE}${__STYLE_TABLE[$__HIDE]};";
                ;;
            DELET)
                __STYLE="${__STYLE}${__STYLE_TABLE[$__DELET]};";
                ;;
            *)
                echo -e "${RED[$BOLD]}BAD STYLE SPECIFIED:${1}$RESET";
                return;
                ;;
        esac
        shift
    done
    echo -e $__OPT "\033[${__STYLE}${__COLOR}${__STRING}${RESET}"
}


F_GRAY()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT GRAY "$__STRING" $*
    fi
}

F_RED()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT RED "$__STRING" $*
    fi
}


F_GREEN()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT GREEN "$__STRING" $*
    fi
}


F_YELLOW()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT YELLOW "$__STRING" $*
    fi
}

F_BLUE()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT BLUE "$__STRING" $*
    fi
}

F_VIOLET()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT VIOLET "$__STRING" $*
    fi
}

F_CYAN()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT CYAN "$__STRING" $*
    fi
}

F_WHITE()
{
    __OPT="";
    if [ "$1" = "-n" ];then
        __OPT="-n";
        shift;
    fi

    if [ -n "$1" ];then
        __STRING="$1";
        shift
        F_CLRPRINT $__OPT WHITE "$__STRING" $*
    fi
}

if [ "$1" = "--test" ];then
    echo -e "${GRAY}GRAY${RED[$UNDERLINE]}RED UNDERLINE$RESET${WHITE[$BOLD]}WHITE BOLD$RESET${YELLOW[$DELET]}YELLOW DELETE$RESET${GREEN[$INVERT]}GREEN INVERT$RESET"
    F_BLUE "BOLD DELETE BLUE TEXT" BOLD DELET
    F_GRAY "GRAY BOLD UNDERLINE TEXT" BOLD UNDERLINE 
    F_CLRPRINT RED "RED BOLD UNDERLINE DELETE INVERT"  BOLD UNDERLINE DELET INVERT
fi
