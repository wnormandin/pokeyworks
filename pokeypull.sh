#!/bin/bash
#
# Pulls changes down to all pokey repos (assumes clean working branch)

paths=(
    "<insert your path>/hosting_tools/"
    "<insert your path>/network_tools/"
    "<insert your path>/pokeygame/"
    "<insert your path>/pokeyworks/"
    "<insert your path>/resources/"
    "<insert your path>/social_media_bots/"
    )

for p in ${paths[@]};
do
    echo "$(cd $p; git pull origin master 2> /dev/null)"
done
