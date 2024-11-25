#!/usr/bin/env bash

current_tag=$(nixos-rebuild list-generations | grep current | grep -Eo '[0-9]+' | head -1)
git tag Gen-$current_tag
git push origin tag Gen-$current_tag