#!/bin/bash
# Post Steam Deck Update Script for pacman and things
# Requires Sudo perms

steamos-readonly disable

# Update pacman
sudo pacman-key --init
sudo pacman-key --populate archlinux

# Update system
sudo pacman -Syu

# Install desired packages
sudo rm -f /etc/X11/tigervnc Xsession
sudo pacman -Syu tigervnc
