Ludo Pagie, 20190506, upgrade_Rpackages.sh

A simple script to update all R-packages from CRAN/BioC in case of a 'major' update of R.  
The script does the following:  
 - determine the R-package directory for the most recent R-version (ie the most recent directory in $USER/R/x86_64-pc-linux-gnu-library)
 - retrieve a list of all packages stored in that directory
 - determines the directory corresponding to the newly installed R-version
 - creates the corresponding R-packages directory
 - installs BiocManager from CRAN
 - installs all remaining packages using BiocManager::install

Note that the script aborts if:  
 - no R-package directory corresponding to a previous R-version exists
 - An R-package directory qcorresponding to the newly installed R-version *does* already exist

Any installed package not available on CRAN/BioC will not be installed

ToDo:  
 - make script more robust
 - make cleaning of the old R-package directories a user controlled option
 - ..


