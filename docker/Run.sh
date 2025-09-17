#!/bin/bash
cd "$(dirname "$0")"
set -eux
cleanup() {
    docker compose -f DockerCompose.yaml rm -fsv
}
trap cleanup EXIT
docker compose -f DockerCompose.yaml up --build