#!/usr/bin/perl
#use Tk;
#use strict;
#use warnings;
use feature ":5.10";
#use File::Copy;
#use List::Util qw( min );
#use List::Util qw( max );
#use List::Util qw(min max);
#use Statistics::Descriptive();

##############################################
print "running my R script with system call\n";
sleep(1);
system "Rscript iris_code.R\n";
print "end program\n";
sleep(3);
###########################################
print "running some R commands with pipe\n";
sleep(1);
open (Rinput, "| R --vanilla")||die "could not start R command line\n";
print Rinput "library(ggplot2)\n";
print Rinput "library(gridExtra)\n";
print Rinput "print('hello world')\n";
print Rinput "print('hello world')\n";
print Rinput "q()\n";# quit R 
print Rinput "n\n";# save workspace image?
close Rinput;
exit;
#############################################
