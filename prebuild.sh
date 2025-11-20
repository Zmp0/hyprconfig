#!/bin/bash

sudo pacman -S --needed --noconfirm - < req.txt
chmod +x start.sh && bash start.sh
