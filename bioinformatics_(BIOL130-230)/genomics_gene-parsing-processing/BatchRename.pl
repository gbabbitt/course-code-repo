#!/usr/bin/perl



print "ENTER BATCH FILE RENAME OPTIONS\n";

print "\n\n\n";
print "Enter a prefix for file names in this batch \n\n";
  $prefix = <STDIN>; 
  chop($prefix);


print "\n\n\n";
print "Enter number of first file name in this batch \n\n";
  $startnumber = <STDIN>; 
  chop($startnumber);


print "OPENING FILES\n\n";

$dir = "MyDirectory";
opendir(DIR,$dir)or die "can't open directory";
print"\n";

print "files in $dir are:\n";


#reinitialize


while ($filename = readdir DIR){
   
   next if $filename =~/^\.\.?$/;
   #print "$filename\n" if -T "$dir/$filename";
   $filecount = $filecount + 1;
   
   $filelocation = "./MyDirectory/$filename";  
   #print "$filelocation\n";
   
  open INFILE, "<$filelocation" or die "could not open REscan file";
  $outname = "$prefix"."$startnumber";
  open OUTFILE, ">./MyDirectory/$outname.txt" or die "could not open outfile"; 
    
  while(<INFILE>){
    chomp;
    #@data = split(/\s+/, $_);
    @data = <INFILE>;
    print "processing file number RE"."$startnumber\n";
    print OUTFILE @data;
    }
  @data = ();
  $startnumber = $startnumber + 1;   
  }
  
  
print "END BATCH PROCESSING PROGRAM\n";

exit;  


