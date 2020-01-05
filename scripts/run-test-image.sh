#!/usr/bin/env bash

IMAGE_TAG="$1"

if [ -z "$IMAGE_TAG" ]; then
    IMAGE_TAG="dotfiles:latest"
fi

command podman run --rm -it "$IMAGE_TAG"
