#!usr/bin/perl
use List::Util qw( shuffle );
use Time::HiRes qw( gettimeofday );
$obsSHUFFLE = "n";    # to observe shuffling on seqs (y = yes n = no)
$shuffleINDELS = "n"; # to shuffle indels as well as subs
$windowSize = 200;    # size of window to shuffle within
$shufflecount  = 1000;  # number of shuffled sequences to produce
$randletter = "n"; # 'y' will randomize and reposition the substitution types
                   # 'n' will simply reposition existing substitutions

#####################################################################
##### The main script takes processes the given FASTA file      #####
##### and stores the sequences in a hash before passing them    #####
##### on to the shuffle function. Note that the FASTA file      #####
##### should only contain two sequences. The first sequence     #####
##### should be the query sequence, i.e. the sequence of        #####
##### interest containing the mutations. The second sequence    #####
##### should be the reference sequence.                         #####
##################################################################### 

### check commandline arguments ###
die "Usage: $0 <fasta file> <output file name>\n" if @ARGV != 2;

### obtain sequences to work with in this implementation ###
$filename = $ARGV[0];
$output = $ARGV[1];
open(FILE, "<"."$filename") or die "Cannot open input file";


%sequences = ();
$name = "";
$q = "";
$ref = "";

while($line = <FILE>){
	if($line =~ m/^\n/ || $line =~ m/^\s/){		### don't use empty lines ###
		
	} elsif($line =~ m/>/) {		### use sequence header as key ###
		
		if($q eq ""){
			$q = $line;
			$q =~ s/>//;
			$q =~ s/\n//;
			$name = $q;
		} else {
			$ref = $line;
			$ref =~ s/>//;
			$ref =~ s/\n//;
			$name = $ref;
		}
		
	} else {	
	
		$tmp = $line;
		$tmp =~ s/\n//;
		
		$sequences{$name} 
			= $sequences{$name} . $tmp;
	   
  } 
}
close(FILE);

### time how long it takes to do 1000 randomizations
### on one given sequence, as well as storing the resulting
### randomizations in a file
$timeOne = int( gettimeofday() * 1000);
open(STORE, ">"."$output");
print STORE "original seqs\n";
print STORE $q . "\n";
print STORE $sequences{$q};
print STORE "\n";
print STORE $ref . "\n";
print STORE $sequences{$ref};
print STORE "\n\n";
print STORE "shuffled seqs\n";
for($n = 0; $n<$shufflecount; $n++){
	print STORE "$n\n";
    print STORE shiftMutations($sequences{$ref}, $sequences{$q}, 100),
		"\n";
    #print "shuffledSeq$n\n";
    #print "$shuffledSeq\n\n";
	

}
close(STORE);
$timeTwo = int( gettimeofday() * 1000);

print $timeTwo-$timeOne, " msec\n";

exit;

#####################################################################
##### This code is intended to shuffle substitution mutations 	#####
##### by comparing two given sequences, the first of which	  	#####
##### is used as an ancestral/reference sequence to identify 	#####
##### mutations in the second sequence. Substitution 		  	#####
##### mutations are then relocated from the place they were	  	#####
##### found to a random location on a copy of the second 		#####
##### sequence. The nucleotide at the random location in the 	#####
##### reference sequence is the same nucleotide in the 	    	#####
##### reference sequence as found at the location of the 		#####
##### substitution mutation. An additional option exists that	#####
##### also shuffles indels, given by the subroutine 			#####
##### 'shiftIndels'. The subroutine returns the randomized		#####
##### sequence.													#####
#####################################################################
sub shiftMutations {
	
	$reference = ($_[0]);		### the 'template' sequence
	$query = ($_[1]);			### the sequence containing mutations
	$shuffledSeq = ($_[1]);		### the sequence to which the changes
								###		are made, based on the query
									
	#$windowSize = uc($_[2]);		### the size of the window
	#print "$windowSize\n";
  
	### determine the length of the shortest sequence even 
	### though you would expect the two given sequences to be of
	### the same length
	$shortestLength;
	if(length($reference) < length($query)){
		$shortestLength = length($reference);
	} else {
		$shortestLength = length($query);
	}
	
	
	### traverse the entire length of the sequence by moving from 
	### window to window
	$windowPos = 0;			### starting position of the current window
	$endLocation = 0;		### ending position of the current window
	$done = "false";		
	while($done ne "true"){
	
		### adjust the ending position relative to the window size
		### but use the remaining length of the sequence when it 
		### is shorter than the given window size
		if( ($windowPos + $windowSize) < $shortestLength ){
			$endLocation = $windowPos + $windowSize;
		} else {
			$endLocation = $shortestLength;
			$done = "true";
		}
		
		@A_locations = ();		### locations of 'A's in window
		@R_locations = ();		### locations of 'R's in window
		@N_locations = ();		### locations of 'N's in window
		@D_locations = ();		### locations of 'D's in window
		@C_locations = ();		### locations of 'C's in window
		@E_locations = ();		### locations of 'E's in window
		@Q_locations = ();		### locations of 'Q's in window
		@G_locations = ();		### locations of 'G's in window
		@H_locations = ();		### locations of 'H's in window
		@I_locations = ();		### locations of 'I's in window
		@L_locations = ();		### locations of 'L's in window
		@K_locations = ();		### locations of 'K's in window
		@M_locations = ();		### locations of 'M's in window
		@F_locations = ();		### locations of 'F's in window
		@P_locations = ();		### locations of 'P's in window
		@S_locations = ();		### locations of 'S's in window
		@T_locations = ();		### locations of 'T's in window
		@W_locations = ();		### locations of 'W's in window
		@Y_locations = ();		### locations of 'Y's in window
		@V_locations = ();		### locations of 'V's in window
		
		### fill the nucLocations collection with all the individual 
		### nucleotide locations found in the reference sequence
		### within the current window, disregarding indels
		for($i = $windowPos; $i<$endLocation; $i++){
			$residue = substr($reference, $i, 1);
			if(substr($query, $i, 1) !~ m/-/ 
				&& ($residue eq substr($query, $i, 1))){
				
				if( $residue eq "A" || $residue eq "a"){
					push(@A_locations, $i);
				} elsif( $residue eq "R" || $residue eq "r"){
					push(@R_locations, $i);
				} elsif( $residue eq "N" || $residue eq "n"){
					push(@N_locations, $i);
				} elsif( $residue eq "D" || $residue eq "d"){
					push(@D_locations, $i);
				} elsif( $residue eq "C" || $residue eq "c"){
					push(@C_locations, $i);
				} elsif( $residue eq "E" || $residue eq "e"){
					push(@E_locations, $i);
				} elsif( $residue eq "Q" || $residue eq "q"){
					push(@Q_locations, $i);
				} elsif( $residue eq "G" || $residue eq "g"){
					push(@G_locations, $i);
				} elsif( $residue eq "H" || $residue eq "h"){
					push(@H_locations, $i);
				} elsif( $residue eq "I" || $residue eq "i"){
					push(@I_locations, $i);
				} elsif( $residue eq "L" || $residue eq "l"){
					push(@L_locations, $i);
				} elsif( $residue eq "K" || $residue eq "k"){
					push(@K_locations, $i);
				} elsif( $residue eq "M" || $residue eq "m"){
					push(@M_locations, $i);
				} elsif( $residue eq "F" || $residue eq "f"){
					push(@F_locations, $i);
				} elsif( $residue eq "P" || $residue eq "p"){
				        push(@P_locations, $i);
				} elsif( $residue eq "S" || $residue eq "s"){
					push(@S_locations, $i);
				} elsif( $residue eq "T" || $residue eq "t"){
					push(@T_locations, $i);
				} elsif( $residue eq "W" || $residue eq "w"){
					push(@W_locations, $i);
				} elsif( $residue eq "Y" || $residue eq "y"){
					push(@Y_locations, $i);
				} elsif( $residue eq "V" || $residue eq "v"){
					push(@V_locations, $i);
				}
				
				
				
				
			}
		}
		
		### randomize the residue locations
		@A_locations = shuffle(@A_locations); 
		@R_locations = shuffle(@R_locations);
		@N_locations = shuffle(@N_locations);
		@D_locations = shuffle(@D_locations);
		@C_locations = shuffle(@C_locations); 
		@E_locations = shuffle(@E_locations);
		@Q_locations = shuffle(@Q_locations);
		@G_locations = shuffle(@G_locations);
		@H_locations = shuffle(@H_locations); 
		@I_locations = shuffle(@I_locations);
		@L_locations = shuffle(@L_locations);
		@K_locations = shuffle(@K_locations);
		@M_locations = shuffle(@M_locations); 
		@F_locations = shuffle(@F_locations);
		@P_locations = shuffle(@P_locations);
		@S_locations = shuffle(@S_locations);
		@T_locations = shuffle(@T_locations); 
		@W_locations = shuffle(@W_locations);
		@Y_locations = shuffle(@Y_locations);
		@V_locations = shuffle(@V_locations);
		
		for($i = $windowPos; $i<$endLocation; $i++){
			
			### swap mutations only if you find a substitution mutation
			if( substr($reference, $i, 1) ne substr($query, $i, 1) 
				&& substr($reference, $i, 1) !~ m/-/ 
				&& substr($query, $i, 1) !~ m/-/){
				
				$referenceRes = substr($reference, $i, 1);
				$mutatedRes = substr($query, $i, 1);
				
				### remove and return first element of shuffled 
				### nucleotide locations to determine where to
				### replace the mutation
				$newLocation = ();
				if($referenceRes eq "A" || $referenceRes eq "a"){
					$newLocation = shift(@A_locations);
				} elsif($referenceRes eq "R" || $referenceRes eq "r"){
					$newLocation = shift(@R_locations);
				} elsif($referenceRes eq "N" || $referenceRes eq "n"){
					$newLocation = shift(@N_locations);
				} elsif($referenceRes eq "D" || $referenceRes eq "d"){
					$newLocation = shift(@D_locations);
				} elsif($referenceRes eq "C" || $referenceRes eq "c"){
					$newLocation = shift(@C_locations);
				} elsif($referenceRes eq "E" || $referenceRes eq "e"){
					$newLocation = shift(@E_locations);
				} elsif($referenceRes eq "Q" || $referenceRes eq "q"){
					$newLocation = shift(@Q_locations);
				} elsif($referenceRes eq "G" || $referenceRes eq "g"){
					$newLocation = shift(@G_locations);
				} elsif($referenceRes eq "H" || $referenceRes eq "h"){
					$newLocation = shift(@H_locations);
				} elsif($referenceRes eq "I" || $referenceRes eq "i"){
					$newLocation = shift(@I_locations);
				} elsif($referenceRes eq "L" || $referenceRes eq "l"){
					$newLocation = shift(@L_locations);
				} elsif($referenceRes eq "K" || $referenceRes eq "k"){
					$newLocation = shift(@K_locations);
				} elsif($referenceRes eq "M" || $referenceRes eq "m"){
					$newLocation = shift(@M_locations);
				} elsif($referenceRes eq "F" || $referenceRes eq "f"){
					$newLocation = shift(@F_locations);
				} elsif($referenceRes eq "P" || $referenceRes eq "p"){
					$newLocation = shift(@P_locations);
				} elsif($referenceRes eq "S" || $referenceRes eq "s"){
					$newLocation = shift(@S_locations);
				} elsif($referenceRes eq "T" || $referenceRes eq "t"){
					$newLocation = shift(@T_locations);
				} elsif($referenceRes eq "W" || $referenceRes eq "w"){
					$newLocation = shift(@W_locations);
				} elsif($referenceRes eq "Y" || $referenceRes eq "y"){
					$newLocation = shift(@Y_locations);
				} elsif($referenceRes eq "V" || $referenceRes eq "v"){
					$newLocation = shift(@V_locations);
				}
				
				
				 ### perform the actual swap
				$resToSwap = substr($query, $newLocation, 1);
	
	                        # option to randomize subs types
	                        #print "prior_resToSwap = "."$resToSwap\n";
		                if ($randletter eq "y") {
		                if ($resToSwap eq "A") {@not = ("R","N","D","C","E","Q","G","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "a") {@not = ("r","n","d","c","e","q","g","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "R") {@not = ("A","N","D","C","E","Q","G","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "r") {@not = ("a","n","d","c","e","q","g","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "N") {@not = ("A","R","D","C","E","Q","G","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "n") {@not = ("a","r","d","c","e","q","g","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "D") {@not = ("A","R","N","C","E","Q","G","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "d") {@not = ("a","r","n","c","e","q","g","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                
				if ($resToSwap eq "C") {@not = ("A","R","N","D","E","Q","G","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "c") {@not = ("a","r","n","d","e","q","g","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "E") {@not = ("A","R","N","D","C","Q","G","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "e") {@not = ("a","r","n","d","c","q","g","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "Q") {@not = ("A","R","N","D","C","E","G","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "q") {@not = ("a","r","n","d","c","e","g","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "G") {@not = ("A","R","N","D","C","E","Q","H","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "g") {@not = ("a","r","n","d","c","e","q","h","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                
				if ($resToSwap eq "H") {@not = ("A","R","N","D","C","E","Q","G","I","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "h") {@not = ("a","r","n","d","c","e","q","g","i","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "I") {@not = ("A","R","N","D","C","E","Q","G","H","L","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "i") {@not = ("a","r","n","d","c","e","q","g","h","l","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "L") {@not = ("A","R","N","D","C","E","Q","G","H","I","K","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "l") {@not = ("a","r","n","d","c","e","q","g","h","i","k","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "K") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","M","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "k") {@not = ("a","r","n","d","c","e","q","g","h","i","l","m","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                
				if ($resToSwap eq "M") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","F","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "m") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","f","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "F") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","M","P","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "f") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","m","p","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "P") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","M","F","S","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "p") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","m","f","s","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "S") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","M","F","P","T","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "s") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","m","f","p","t","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                
				if ($resToSwap eq "T") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","M","F","P","S","W","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "t") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","m","f","p","s","w","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "W") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","M","F","P","S","T","Y","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "w") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","m","f","p","s","t","y","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "Y") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","M","F","P","S","T","W","V"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "y") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","m","f","p","s","t","w","v"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                if ($resToSwap eq "V") {@not = ("A","R","N","D","C","E","Q","G","H","I","L","K","M","F","P","S","T","W","Y"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}
		                if ($resToSwap eq "v") {@not = ("a","r","n","d","c","e","q","g","h","i","l","k","m","f","p","s","t","w","y"); @rand_not = shuffle(@not); $mutatedRes = shift(@rand_not);}		
		                
				#print "post_mutatedRes = "."$mutatedRes\n";
		                
				}
	
	                       
				
                         if ($obsSHUFFLE ne "y"){
                            substr($shuffledSeq, $newLocation, 1, ($mutatedRes));
			    }
                         if ($obsSHUFFLE eq "y"){
                         if ($resToSwap eq "a" || $resToSwap eq "r" || $resToSwap eq "n" || $resToSwap eq "d" ||
			     $resToSwap eq "c" || $resToSwap eq "e" || $resToSwap eq "q" || $resToSwap eq "g" ||
			     $resToSwap eq "h" || $resToSwap eq "i" || $resToSwap eq "l" || $resToSwap eq "k" ||
			     $resToSwap eq "m" || $resToSwap eq "f" || $resToSwap eq "p" || $resToSwap eq "s" ||
			     $resToSwap eq "t" || $resToSwap eq "w" || $resToSwap eq "y" || $resToSwap eq "v"){
                            substr($shuffledSeq, $newLocation, 1, (uc $mutatedRes));  # to observe shuffling on sequences 
                            }
                         if ($resToSwap eq "A" || $resToSwap eq "R" || $resToSwap eq "N" || $resToSwap eq "D" ||
			     $resToSwap eq "C" || $resToSwap eq "E" || $resToSwap eq "Q" || $resToSwap eq "G" ||
			     $resToSwap eq "H" || $resToSwap eq "I" || $resToSwap eq "L" || $resToSwap eq "K" ||
			     $resToSwap eq "M" || $resToSwap eq "F" || $resToSwap eq "P" || $resToSwap eq "S" ||
			     $resToSwap eq "T" || $resToSwap eq "W" || $resToSwap eq "Y" || $resToSwap eq "V"){
                            substr($shuffledSeq, $newLocation, 1, (lc $mutatedRes));  
                            }
        }
        
        
        substr($shuffledSeq, $i, 1, ($resToSwap));
				
			}
		}
		### move to next window
		$windowPos += $windowSize;
	}
	
	
	#print substr($reference, 0, $windowSize), "\n\n";
	#print substr($query, 0, $windowSize), "\n\n";
	#print substr($shuffledSeq, 0, $windowSize), "\n\n";
	
	
	### shuffle indels around as well 
	if ($shuffleINDELS eq "y"){
  $shuffledSeq = shiftIndels($reference, $shuffledSeq, $windowSize);
	}
	#print substr($shuffledSeq, 0, $windowSize), "\n";
	
	return $shuffledSeq;
	
	
	
	
}


#####################################################################
##### This subroutine shuffles around indels. It handles 		#####
##### insertions by identifying '-'s in the reference 			#####
##### sequence, extracting the corresponding 'word' in the 		#####
##### query sequence, concatinating the surrounding sequence	#####
##### ends, and inserting the found 'word' at a new random		#####
##### location within the current window. Deletions, on the 	#####
##### other hand, are dealt with by identifying '-'s in the 	#####
##### query sequence, determining the length of the gap, 		#####
##### replacing the '-'s in the query sequence with the 		#####
##### corresponding nucleotides from the reference sequence, 	#####
##### and then replacing nucleotides on the query sequence at   #####
##### a random location with a gap of the same length.			#####
#####################################################################
sub shiftIndels {

	$reference = $_[0];		### the 'template' sequence
	$query = $_[1];			### the sequence containing mutations
	$indelShiftSeq = $_[1];		### the sequence to which the changes
								###		are made
	
	#$windowSize = $_[2];		### the window size	
	
	### determine the length of the shortest sequence even 
	### though you would expect the two given sequences to be of
	### the same length
	$shortestLength;
	if(length($reference) < length($query)){
		$shortestLength = length($reference);
	} else {
		$shortestLength = length($query);
	}
	
	### traverse the entire length of the sequence by moving from 
	### window to window
	$windowPos = 0;			### starting postition of current window
	$endLocation = 0;		### ending position of current window	
	$done = "false";
	while($done ne "true"){
	
		### adjust the ending position relative to the window size
		### but use the remaining length of the sequence when it 
		### is shorter than the given window size
		if( ($windowPos + $windowSize) < $shortestLength ){
			$endLocation = $windowPos + $windowSize;
		} else {
			$endLocation = $shortestLength;
			$done = "true";
		}
	
		for($i = $windowPos; $i<$endLocation; $i++){
		
			### handle insertions, seens as '-' in the reference sequence
			### making sure that the current '-' is not part of a larger,
			### previously handled insertion
			if( substr($reference, $i, 1) eq "-" 
				&& substr($reference, $i-1, 1) ne "-"){
			
				### determine length of the insertion
				$nextBase = substr($reference, $i+1, 1);
				$length = 1;
				while($nextBase eq "-"){
					$length++;
					$nextBase = substr($reference, $i+$length, 1);
				}
				$insertion = substr($query, $i, $length);
				
				### concatenate sequence around insertion
				$indelShiftSeq = substr($indelShiftSeq, 0, $i) 
					. substr($indelShiftSeq, $i+$length);
				
				### place insertion at random different location
				### that is not the current position but within the 
				### current window
				$newLocation = int(rand($windowSize-$length))
					+ $windowPos;
				while($newLocation == $i 
					&& (substr($query, $newLocation, 1) ne "-")){
					$newLocation = int(rand($windowSize-$length))
						+ $windowPos;
				}
				$indelShiftSeq = substr($indelShiftSeq, 0, $newLocation)
					. $insertion . substr($indelShiftSeq, $newLocation);
			} 
			
			### handle deletions, seen as '-' in the query sequence
			### making sure that the current '-' is not part of a larger,
			### previously handled deletion
			elsif( substr($query, $i, 1) eq "-" 
				&& substr($query, $i-1, 1) ne "-"){
				
				### determine length of the deletion
				$nextBase = substr($query, $i+1, 1);
				$length = 1;
				while($nextBase eq "-"){
					$length++;
					$nextBase = substr($query, $i+$length, 1);
				}
				$deletion = substr($reference, $i, $length);
				
				### replace gap with deleted sequence
				substr($indelShiftSeq, $i, $length, $deletion);
				
				### create a new gap of the same length at a random position
				$newLocation = int(rand($windowSize-$length))
					+ $windowPos;
				while($newLocation == $i 
					&& (substr($reference, $newLocation, $length) =~ m/-/)){
					$newLocation = int(rand($windowSize-$length))
						+ $windowPos;
				}
				
				$gapSequence = "-";
				for($j = 1; $j<$length; $j++){
					$gapSequence = $gapSequence . "-";
				}
				
				substr($indelShiftSeq, $newLocation, $length, $gapSequence);
			}
		}
		### move to next window
		$windowPos += $windowSize;
	}
	
	return $indelShiftSeq;

}