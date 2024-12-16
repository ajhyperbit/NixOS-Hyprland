#!/usr/bin/env bash

host=${1:-}

if [ -z $host ]; then
    echo "Script requires a agrument for a host name. Current host names are "nixos" or "nixtop.""
    exit 1
fi

current_tag=$(nixos-rebuild list-generations | grep current | grep -Eo '[0-9]+' | head -1)
git tag Gen-$host-$current_tag
git push origin tag Gen-$host-$current_tag