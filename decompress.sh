#!/bin/bash
#
# decompress all available files
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


decompress_file()
{
    __DIR=""

    case "$1" in
        *.rar)
            __DIR="${1%%.rar}"
            mkdir "$__DIR"
            unrar x "$1" "$__DIR/"  > /dev/null
            ;;
        *.zip)
            __DIR="${1%%.zip}";
            mkdir "$__DIR"
            unzip "$1" -d "$__DIR" > /dev/null
            ;;
        *.tgz|*.tar.gz|*.tar|*.tar.bz2)
            case "$1" in
                *.tgz)
                    __DIR="${1%%.tgz}";
                    ;;
                *.tar.gz)
                    __DIR="${1%%.tar.gz}";
                    ;;
                *.tar)
                    __DIR="${1%%.tar}";
                    ;;
                *.tar.bz2)
                    __DIR="${1%%.tar.bz2}";
                    ;;
            esac
            mkdir "$__DIR";
            tar xf "$1" -C "$__DIR"  > /dev/null
            ;;
        *.7z)
            __DIR="${1%%.7z}";
            mkdir "$__DIR";
            7z x "$1" "-o$__DIR" > /dev/null
            ;;
        *.bz2)
            __DIR="${1%%.bz2}";
            bunzip "$1" -c > "$__DIR"
            ;;
    esac

    if [ -n "$__DIR" -a -d "$__DIR" ];then
        i=0;
        name="";

        for x in "$__DIR"/*;
        do
            if [ "$x" != "$__DIR/*" ];then
                ((i++));
                name="$x";
            fi
        done

        if [[ $i == 1 ]];then
            mv "$name" ".${__DIR}";
            rd "$__DIR";
            mv ".${__DIR}" "$__DIR"
        fi
    fi

    echo "$__DIR"
}


