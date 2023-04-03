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
```bash nix develop .#dev -c $SHELL``` invokes user shell with dependencies in path. You can swap $SHELL for
other command or specific shell like `nix develop .#dev -c bash/zsh/nu`. Dependencies are listed in *flake.nix* file
at output

## Tests in CI
Testing in this repo is done via Github Actions (*.github/workflows/test.yml*) and *ci_tests.sh* script.
Thanks to that it would be easier to change testing environment from Github to
other service provider. Using nix in test actions allows for easy workflow with test enviroment testable
on local machine. Tests are run via
`nix develop .#test -c sh ./ci-tests.sh` and can be invoked in any CI provider or on local machine.

## Continous Deployment
Continous Deployment is architecture specific, so this part is used more as general guideline.
For small apps hosted on one machine you can build image in CI and copy it over SSH
onto deployment machine.
In this repo CD is triggered via Github Actions after tests pass. For more info
look into *deploy.sh* script

