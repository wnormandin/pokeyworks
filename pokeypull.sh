#!/bin/bash
#
# Pulls changes down to all pokey repos (assumes clean working branch)

paths=(
    "/home/bill/python/hosting_tools/"
    "/home/bill/python/network_tools/"
    "/home/bill/python/pokeygame/"
    "/home/bill/python/pokeyworks/"
    "/home/bill/python/resources/"
    "/home/bill/python/social_media_bots/"
    )

for p in ${paths[@]};
do
    echo "$(cd $p; git pull origin master)"
done
