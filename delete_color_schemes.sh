#!/usr/bin/env bash

echo -e "This script deletes all the color schemes and\nsets up the color schmeme as the default one.\n"
echo "Delete all color schemes? Type \"YES\" to continue."

read confirmation
if [[ $(echo $confirmation | tr '[:lower:]' '[:upper:]') != YES ]]
then
	echo "Color schemes not deleted."
	exit 0
else
	echo "Deleteing all color schemes"
	gconftool-2 --recursive-unset /apps/gnome-terminal
fi