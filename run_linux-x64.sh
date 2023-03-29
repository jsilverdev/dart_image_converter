#!/bin/bash
terms=(emulator1 emulator2 emulator3)
detected_term=""
for t in ${terms[*]}
do
    if [ $(command -v $t) ]
    then
        detected_term=$t
        break
    fi
done

[ -x "$(command -v x-terminal-emulator)" ] && detected_term="x-terminal-emulator"

[ -x "$(command -v gnome-terminal)" ] && detected_term="gnome-terminal"

[ -x "$(command -v xterm)" ] && detected_term="xterm"

[ -x "$(command -v konsole)" ] && detected_term="konsole"

if [ "$detected_term" = "" ]
then
    echo "Empty terminal"
    exit 0
fi

$detected_term -e "bash -c 'binaries/linux-v1.1.5-x64; $SHELL'"