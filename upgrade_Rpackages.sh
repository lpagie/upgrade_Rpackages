#!/bin/bash

# Ludo Pagie, 20190506, upgrade_Rpackages.sh
# 
# A simple script to update all R-packages from CRAN/BioC in case of a 'major'
# update of R.
# The script does the following:
#  - determine the R-package directory for the most recent R-version (ie the most recent directory in $USER/R/x86_64-pc-linux-gnu-library)
#  - retrieve a list of all packages stored in that directory
#  - determines the directory corresponding to the newly installed R-version
#  - creates the corresponding R-packages directory
#  - installs BiocManager from CRAN
#  - installs all remaining packages using BiocManager::install
# Note that the script aborts if:
#  - no R-package directory corresponding to a previous R-version exists
#  - An R-package directory qcorresponding to the newly installed R-version *does* already exist
# Any installed package not available on CRAN/BioC will not be installed
#
# ToDo:
#  - make script more robust
#  - make cleaning of the old R-package directories a user controlled option
#  - ...
#

# get the dir path where the new packages should be installed
NEWDIR=$( Rscript -e "cat(normalizePath(Sys.getenv(\"R_LIBS_USER\")))" )
# if NEWDIR exists already, abort
if [ -d "${NEWDIR}" ]; then
  echo "the R-package directory for the current R version (${NEWDIR}) already exists, aborting"
  exit 1
fi

# if NEWDIR does not exist the packages we want to update are in the most recent R_LIBS_USER directory
# get the dir path which contains all old packages
OLDDIR=$( for d in ${HOME}/R/x86_64-pc-linux-gnu-library/*; do echo $PWD/$d; done | sort -n | tail -n 1 )
# if OLDDIR does not exist abort
if [ ! -d "${OLDDIR}" ]; then
  echo "no R-package directory for any previous R version exists, aborting"
  exit 1
fi

# get list of packages installed in old dir
oldpackages=$( Rscript -e 'cat( sprintf( " \"%s\" ", rownames(installed.packages( "'"${OLDDIR}"'" ))),sep=",") ' )
echo "installing the following packages in ${NEWDIR}:"
echo "${oldpackages}"

# create the NEWDIR
mkdir -p "${NEWDIR}"
# install BiocManager and all other packages using BiocManager
echo 'install.packages("BiocManager"); BiocManager::install(c('"${oldpackages}"'));' | R --no-save

