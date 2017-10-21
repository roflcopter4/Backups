#!/bin/sh

DEBUG=false

ShowUsage() {
    echo "Usage: $0  [local dir] <system dir>"
    echo "Will remove fonts from local dir found in system dir. Specifying the"
    echo "system dir is optional, '/usr/share/fonts' is the default."
    exit 1
}

if [ "$#" -eq 0 ] || [ "$1" = '-h' -o "$1" = '--help' ]; then
    ShowUsage
elif [ "$#" -eq 1 ]; then
    locDir="$(realpath "$1")"
    sysDir=/usr/share/fonts
elif [ "$#" -eq 2 ]; then
    locDir="$(realpath "$1")"
    sysDir="$(realpath "$2")"
else
    echo "Too many paramaters."
    ShowUsage
fi


for file1 in "$locDir"/*; do
    file1_base="$(basename "$file1")"
    if [ -d "$file1" ]; then
        echo "File 1 ->""$file1"" is a dir!"
        for file2 in "$file1"/*; do
            file2_base="$(basename "$file2")"
            if [ -f "$sysDir"/"$file1_base"/"$file2_base" ]; then
                echo "$file1"/"$file2_base""		is a duplicate, deleting"
                ! $DEBUG && rm -f "$file2"
            fi
        done
        
    else
        if [ -f "$sysDir"/"$file1_base" ]; then
            echo "$file1""		is a duplicate, deleting"
            ! $DEBUG && rm -f "$file1"
            
        else
            for sysFile1 in "$sysDir"/*; do
                if [ -d "$sysFile1" ]; then
                    if [ -f "$sysFile1"/"$file1_base" ]; then
                        echo "$file1""		is a duplicate, deleting"
                        ! $DEBUG && rm -f "$file1"
                    fi
                fi
            done
        fi
    fi
done