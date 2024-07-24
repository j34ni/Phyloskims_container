# Phyloskims container

This is a Dockerfile based on Ubuntu22.04 to run Phyloskims, it it a modified version of the original recipe from https://gricad-gitlab.univ-grenoble-alpes.fr/eric.coissac/phyloskim to sort out ambiguities and resolve conflicts so that it could still
be built in 2024/06/15.

Only the recipe has been updated, the source code for the software itself was not modified in any way, and users will still find that the executables are located in **/org-assembler** and **/bin**.

# Warning

**This container was not tested** and if you want to contribute with an example of usage (including all the necessary inputs and command lines), please get in touch.

# To pull the container

## with Docker

`docker pull quay.io/jeani/phyloskims:main`

## with Apptainer

`apptainer pull docker://quay.io/jeani/phyloskims:main`
