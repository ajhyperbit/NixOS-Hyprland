#!/usr/bin/env bash

## Usage
usage () {
    printf "Usage:\t $0 <host> <rebuild method>\n\n"
    printf "host:\t Current valid host names are \"nixos\" or \"nixtop.\"\n"
    printf "rebuild method:\t Rebuild methods are either switch, boot, test, build, or dry-activate.\n"
    printf "Arguments put after the ones listed above will be used as arguments for nixos-rebuild command.\n\n"
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
    printf "Don't recognize your option exiting...\n\n"
    usage
    exit 3;
fi

host=${1:-}
reswitch=${2:-}
# Capture all arguments into a variable for use with nixos-rebuild
args=${@:3}  # Capture arguments starting from the 3rd argument
user=$(logname)
#LINK - https://unix.stackexchange.com/questions/479102/how-can-i-filter-read-only-file-systems-out-of-df-output#:~:text=df%20%2D%2Doutput%3Dpcent%2Ctarget%20%24(mount%20%2Dt%20ext4%20%7C%20grep%20rw%20%7C%20cut%20%2Dd%22%20%22%20%2Df1)
storage=$(df --output=pcent,target $(mount -t ext4 | grep rw | cut -d" " -f1) | head -n -1)


#printf "$host\t $reswitch \t $args \t $user\n\n"

if [ -z "$host" ] || [ -z "$reswitch" ]; then
    echo "Usage: $0 <host> <rebuild method>"
    echo "  <host>: 'nixos' or 'nixtop'"
    echo "  <rebuild method>: 'switch', 'boot', 'test', 'build', or 'dry-activate'"
    exit 4;
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
            exit 5;
            ;;
        #REVIEW - Requires Testing
        #[sS]  ) printf "Running as sudo...\n"
        #    eval "sudo $command"
        #    ;;    
        *     ) printf "%b" "Unexpected answer '$answer'!\n" >&2
            exit 3;
            ;;
    esac
}

choose "n" "Do you want to update flake.lock? [(Y)es/(N)o] (Default: No): " "source ~/NixOS-Hyprland/update-flake.sh"

echo "NixOS Rebuilding..."

# Rebuild, output simplified errors, log trackebacks
sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1) || grep -P -n "(?|(\/home\/"$user"\/NixOS-Hyprland\/([a-zA-Z]+)\.nix)|(hosts\/([a-zA-Z]+)\/([a-zA-Z]+).nix))" nixos-switch.log | sed 's/:[[:blank:]]*/: /'
#REVIEW - Testing required
#NOTE - If the above command doesn't function correctly, then the if statement below can replaces it.
#if [ -z "args" ]; then
#sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1) || grep -P -n "(?|(\/home\/"$user"\/NixOS-Hyprland\/([a-zA-Z]+)\.nix)|(hosts\/([a-zA-Z]+)\/([a-zA-Z]+).nix))" nixos-switch.log | sed 's/:[[:blank:]]*/: /'
#else
#sudo nixos-rebuild "$reswitch" --upgrade --show-trace --flake .#"$host" "$args" &>nixos-switch.log || (cat nixos-switch.log | grep --color error && exit 1) || grep -P -n "(?|(\/home\/"$user"\/NixOS-Hyprland\/([a-zA-Z]+)\.nix)|(hosts\/([a-zA-Z]+)\/([a-zA-Z]+).nix))" nixos-switch.log | sed 's/:[[:blank:]]*/: /'
#fi
#REVIEW - Testing required

current_tag=$(nixos-rebuild list-generations | grep current | grep -Eo '[0-9]+' | head -1)

hostname=$(uname -n)

#hash=$(git rev-parse --short HEAD) #Works to get the hash, but doesn't indicate if it is dirty

#Pulled from https://github.com/NixOS/nixpkgs/blob/66aa98b29099c636622a9d9c18370f13701716f6/pkgs/os-specific/linux/nixos-rebuild/nixos-rebuild.sh#L596
hash=$(git describe --always --dirty)

#TODO: Figure out how to add a timer to choose{} so it won't just infintely wait for a prompt

choose "y" "Do you want to tag Gen-"${hostname}"-"${current_tag}"-"${hash}"? [(Y)es/(N)o/(Q)uit] (Default: Yes): " "source ~/NixOS-Hyprland/tag.sh"

#REVIEW - Testing required
#if ["$hostname" == "nixos"]; then
#printf "\n"%s"\n" "$storage"
#else
#:
#fi
#REVIEW - Testing required

#TODO: add a way to run nix-collect garbage with sudo?

#choose "n" "Do you want to run the nix garbage collector? [(Y)es/(S)udo/(N)o/(Q)uit] (Default: No): " "nix-collect-garbage -d &> nix-collect-garbage.log"

choose "n" "Do you want to run the nix garbage collector? [(Y)es/(N)o/(Q)uit] (Default: No): " "nix-collect-garbage -d &> nix-collect-garbage.log"

choose "n" "Do you want to trim generations? [(Y)es/(N)o/(Q)uit] (Default: No): " "source ~/NixOS-Hyprland/trim-generations.sh"

exit 0;