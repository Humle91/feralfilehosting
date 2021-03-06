#!/bin/bash
# wget -qNO ~/autodlport.sh http://git.io/vCft_Q && bash ~/autodlport.sh
# Autodl change ports and pass
port=$(shuf -i 6000-50000 -n 1)
if [[ -f ~/.autodl/autodl.cfg && -f ~/www/$(whoami).$(hostname)/public_html/rutorrent/plugins/autodl-irssi/conf.php ]]
then
    echo
    echo "This script will change your password and port for autodl and the rutorrent plugin, then restart irssi."
    echo
    read -ep "Enter Password (No spaces please!): " pass
    echo
    echo -e "You entered" "\033[32m""$pass""\e[0m" "as your password."
    echo
    read -ep "Please confirm this is the password you wish to use [y/n]: " confirm
    echo
    if [[ $confirm =~ ^[Yy]$ ]]
    then
        sed -ri 's/(.*)gui-server-port =(.*)/gui-server-port = '$port'/g' ~/.autodl/autodl.cfg
        sed -ri 's/(.*)gui-server-password =(.*)/gui-server-password = '$pass'/g' ~/.autodl/autodl.cfg
        echo -e "<?php\n\$autodlPort = $port;\n\$autodlPassword = \"$pass\";\n?>" > ~/www/$(whoami).$(hostname)/public_html/rutorrent/plugins/autodl-irssi/conf.php
        killall -9 irssi -u $(whoami) 2> /dev/null 
        screen -wipe > /dev/null 2>&1
        screen -dmS autodl irssi
        echo "The port and password have been updated. Attach to the running screen using this command:"
        echo
        echo -e "\033[32m""screen -r autodl""\e[0m"
        echo
    else
        bash ~/autodlport.sh
    fi        
else
    echo
    echo -e "The required files do not exist, please install autodl irssi using the bash script first."
    echo
    if [[ ! -f ~/.autodl/autodl.cfg ]]
    then
        echo -e "\033[36m""~/.autodl/autodl.cfg""\e[0m"" is missing"
    fi
    if [[ ! -f ~/www/$(whoami).$(hostname)/public_html/rutorrent/plugins/autodl-irssi/conf.php ]]
    then
        echo -e "\033[36m""/rutorrent/plugins/autodl-irssi/conf.php""\e[0m"" is missing"
    fi
    echo
fi