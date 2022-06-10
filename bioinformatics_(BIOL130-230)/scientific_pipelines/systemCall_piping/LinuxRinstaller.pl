#!/usr/bin/perl
use File::Copy;

print "INSTALLATION SCRIPT FOR R AND R PACKAGE DEPENDENCIES\n";

# check R installation
print "\nIs R already installed? (y/n)  note: can type 'R' in another terminal to check\n\n";
  $yn = <STDIN>; 
  chop($yn);
if($yn eq "y" || $yn eq "Y"){print "\n R installation skipped\n\n"; goto Rskip;}
sleep(1); print "\ninstalling R\n\n"; sleep(1); system('sudo apt-get install r-base r-base-dev'); sleep(1);
sleep(1); print "\ninstalling R and R packages\n\n";
Rskip:
SKIP:
print "\nAre all necessary R packages installed? (y/n)\n\n";
  $yn = <STDIN>; 
  chop($yn);
if($yn eq "y" || $yn eq "Y"){print "\n R installation skipped\n\n"; print "R INSTALLATION FAILED\n"; exit;}

sleep(1); print "\ninstalling some R packages  (type 'y' if this hangs)\n\n";
#install R and R packages
open (Rinput, "| R --vanilla")||die "could not start R command line\n";
print Rinput "chooseCRANmirror(graphics = getOption('menu.graphics'), ind = 81, local.only = TRUE)\n";
print Rinput "install.packages('ggplot2')\n";
print Rinput "install.packages('gridExtra')\n";
print Rinput "install.packages('dplyr')\n";
print Rinput "install.packages('caret')\n";
print Rinput "install.packages('FNN')\n";
print Rinput "install.packages('e1071')\n";
print Rinput "install.packages('kernlab')\n";
print Rinput "install.packages('liquidSVM')\n";
# load some libraries to check installation
print Rinput "library(ggplot2)\n";
print Rinput "library(gridExtra)\n";
print Rinput "library(lattice)\n";
print Rinput "library(FNN)\n";
# write to output file and quit R
print Rinput "q()\n";# quit R 
print Rinput "n\n";# save workspace image?
close Rinput;
print "\n\n";

print "R INSTALLATION COMPLETE\n";

exit;  


