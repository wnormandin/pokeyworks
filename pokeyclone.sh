#!/bin/bash
#
#   PokeyCode Installer
#
# Arguments:
#
#   -g = install pokeygame
#   -h = install hosting tools
#   -n = install network tools
#   -s = install social media bots
#   -a = install all
#
#   Pokeyworks is required by all repos and is
#   cloned by default
#
# Repositories
w="https://github.com/wnormandin/pokeyworks.git"
h="https://github.com/wnormandin/hosting_tools.git"
s="https://github.com/wnormandin/social_media_bots.git"
g="https://github.com/wnormandin/pokeygame.git"
n="https://github.com/wnormandin/network_tools.git"
x="https://github.com/wnormandin/resources.git"

usage=(
    "Usage :  ./pokeyclone.sh [OPTION(S)]... | -r [REPO]... | -h"
    "Options:"
    "-t         : Clone hosting tools"
    "-g         : Clone the PokeyGame framework"
    "-n         : Clone network tools"
    "-s         : Clone social media bots"
    "-a         : Clone all core repositories"
    "-x         : Clone extras in the /resources repository"
    "-e         : Add to PYTHONPATH"
    "-h         : Display usage message"
    "-l         : Exclude PokeyWorks"
    "Uninstall:"
    "-r REPO    : Remove the specified repository"
    "             where REPO is in the current path"
    )

print_usage(){
    msg="This utility clones repositories into the current directory"
    echo -e "$msg"
    printf "%s\n" "${usage[@]}"
    }

EXCLUDE=
REPO=
ADD_PATH=
RESOURCES=
LIST=()
while getopts "tgnsaehlxr:" OPTION
do
    case $OPTION in
        h) print_usage; exit 1;;
        t) LIST+=("$h");;
        g) LIST+=("$g");;
        n) LIST+=("$n");;
        s) LIST+=("$s");;
        a) LIST+=("$h" "$g" "$n" "$s");;
        x) RESOURCES=true;;
        e) ADD_PATH=true;;
        l) EXCLUDE=true;;
        r) REPO=$OPTARG;;
        ?) print_usage; exit;;
    esac
done

# Handle uninstall operations first if present
if [[ ! -z $REPO ]]; then
    echo -n "Remove repository $REPO ?: "
    read -n 1 ch
    echo
    if [[ ${ch,,} -eq "y" ]]; then
        rm -r "$REPO"
        exit
    else
        echo "Exiting!"
        exit
    fi
fi

# Verify there is a list of items to be cloned when ADD_PATH exists
# and EXCLUDE is true (excluding the default PokeyWorks installation)
if [[ (! -z $ADD_PATH && ! -z $EXCLUDE) && ${#LIST[@]} -eq 0 ]]; then
    echo "No operations to perform with current argument list!"
    print_usage
    exit
fi

if [[ -z $EXCLUDE ]]; then
    LIST+=("$w")
fi

if [[ -z $RESOURCES ]]; then
    LIST+=("$x")
fi

# Clone repo list
for item in "${LIST[@]}"
do
    git clone "$item"
done

# !! NOT regular file symlink safe
if [[ ! -z $ADD_PATH ]]; then
    this_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)"
    line="export PYTHONPATH="'${PYTHONPATH}':$this_path""
    echo $line  >> ~/.bashrc
    touch "__init__.py"
    source ~/.bashrc
fi
