#!/usr/bin/env bash

DOCKERFILE="$1"
IMAGE_TAG="$2"

if [ -z "$DOCKERFILE" ]; then
    DOCKERFILE="Dockerfile.fedora"
fi

if [ -z "$IMAGE_TAG" ]; then
    IMAGE_TAG="dotfiles:latest"
fi

command podman build -t "$IMAGE_TAG" -f "$DOCKERFILE"
