# nix-docker-monorepo-app
Example monorepo app consisting of couple services. This repository
was made to be a good starting point for people looking into how to integrate nix into their workflow.
If you have any suggestions how this could be improved feel free to open issue.

This repo should cover:
- dev environment
- test in github CI
- example CD with docker-compose

## Development setup
Nix flake file contains all dev dependencies needed to work on the project. The following command:
`nix develop .#dev -c $SHELL` invokes user shell with dependencies in path. You can swap $SHELL for
other command or specific shell like `nix develop .#dev -c bash/zsh/nu`. Dependencies are listed in *flake.nix* file
at output > devshells > *shellName*

## Tests in CI
Testing in this repo is done via Github Actions (*.github/workflows/test.yml*) and *ci_tests.sh* script.
Thanks to that it would be easier to change testing environment from Github to
other service provider. Using nix in test actions allows for easy workflow with test enviroment testable
on local machine. Tests are run via
`nix develop .#test -c sh ./ci-tests.sh` and can be invoked in any CI provider or on local machine.
Each service is responsible for it's own tests and *ci-tests.sh* script is responsible for invoking tests, collecting results
and throwing exit_code=1 if any test fails.

## Continous Deployment
Continous Deployment is architecture specific, so this part is used more as general guideline.
For small apps hosted on one machine you can build image in CI and copy it over SSH
onto deployment machine.
In this repo CD is triggered via Github Actions after tests pass. For more info
look into *deploy.sh* script. Bigger apps should push images to registry so any production machine
can access build artifacts.

## Containerisation
Containers are made with Nix dockertools. Thanks to that images should be reproducible and have minimal size. For more info look into flake.nix at *packages* section.

## Docker Compose
Every project has 2 types of dependencies - internal and external. I split compose files to reflect that. There are three compose files in this project
- compose.yml
  root compose image exposing external dependencies used both in dev and procution environments
- compose.dev.yml
  overrites and adds new images of compose.yml needed in dev environment. It exposes ports so you can access those services (like database) on local machine
  while developing your services
- compose.prod.yml
  runs project images (frontend and backend in this case)

Thanks to this structure dev enviroment can be created via:
`docker compose -f compose.yml -f compose.dev.yml up` and app in production cab be created with `docker compose -f compose.yml -f compose.prod.yml up`