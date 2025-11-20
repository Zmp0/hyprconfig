#!/bin/bash

set -e

sudo pacman -Syu --noconfirm --needed \
	lolcat 7zip nano \

chmod +x start.sh && bash start.sh
