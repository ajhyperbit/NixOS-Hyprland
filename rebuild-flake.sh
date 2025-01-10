#!/usr/bin/env bash

## Usage
usage () {
    printf "Usage:\t $0 <host> <rebuild method>\n\n"
    printf "host:\t Current valid host names are \"nixos\" or \"nixtop.\"\n"
    printf "rebuild method:\t Rebuild methods are either switch, boot, test, build, or dry-activate.\n\n"
    printf "More details on rebuild methods here: https://nixos.wiki/wiki/Nixos-rebuild\n"
}

if [ $# -eq 1 ]; then      # if help requested
    if [ $1 = "-h" ]; then
         usage
         exit 1;
    fi
    if [ $1 = "--help" ]; then
         usage
         exit 2;
    fi
    printf "Don't recognise your option exiting...\n\n"
    usage
    exit 3;
fi

host=${1:-}
reswitch=${2:-}

if [ -z "$host" ] || [ -z "$reswitch" ]; then
    echo "Usage: $0 <host> <rebuild method>"
    echo "  <host>: 'nixos' or 'nixtop'"
    echo "  <rebuild method>: 'switch', 'boot', 'test', 'build', or 'dry-activate'"
    exit 4
fi

#Code block for choices
choose () {
    local default="$1"
    local prompt="$2"
    local answer
    local command="$3"

    read -p "$prompt" answer
    [ -z "$answer" ] && answer="$default"

    case "$answer" in
        [yY1] ) #printf "answered yes!\n"
            eval "$command"
            ;;
        [nN0] ) printf "Ok.\n"
            ;;
        [qQ]  ) printf "Exiting....\n"
            exit 5
            ;;
        *     ) printf "%b" "Unexpected answer '$answer'!\n" >&2
            exit 3;
            ;;
    esac
}

choose "n" "Do you want to update flake.lock? [(Y)es/(N)o] (Default: No): " "source ~/NixOS-Hyprland/update-flake.sh"

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1) || grep -P -n "(?|(\/home\/ajhyperbit\/NixOS-Hyprland\/([a-zA-Z]+)\.nix)|(hosts\/([a-zA-Z]+)\/([a-zA-Z]+).nix))" nixos-switch.log | sed 's/:[[:blank:]]*/: /'

#source ~/NixOS-Hyprland/tag.sh

#printf "Choose prompt:\n"

current_tag1=$(nixos-rebuild list-generations | grep current | grep -Eo '[0-9]+' | head -1)

hostname=$(uname -n)

#TODO: Figure out how to add a timer to choose{} so it won't just infintely wait for a prompt

choose "y" "Do you want to tag Gen-"${hostname}"-"${current_tag1}"? [(Y)es/(N)o/(Q)uit] (Default: Yes): " "source ~/NixOS-Hyprland/tag.sh"

choose "n" "Do you want to run the nix garbage collector? [(Y)es/(N)o/(Q)uit] (Default: No): " "sudo nix-collect-garbage -d"

choose "n" "Do you want to trim generations? [(Y)es/(N)o/(Q)uit] (Default: No): " "source ~/NixOS-Hyprland/trim-generations.sh"

exit 0;