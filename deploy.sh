#!/bin/bash

containersToBuild=("frontendContainer" "backendContainer")

for container in ${containersToBuild[@]}; do
  nix build .#$container
  # push docker to registry / send it over ssh to production host or in our example load it locally
  docker load < result
  rm ./result
done

docker compose -f compose.yml -f compose.prod.yml up -d
### if you want to invoke command over ssh use
# docker compose -H "ssh://name@host" -f compose.yml -f compose.prod.yml up -d

