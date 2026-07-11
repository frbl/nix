#!/bin/sh

# Set up home-manager
nix-channel --add https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz home-manager
nix-channel --update

nix-shell '<home-manager>' -A install

rm -rf ~/.config/home-manager/home.nix
ln -s ~/nix/home.nix ~/.config/home-manager/home.nix

