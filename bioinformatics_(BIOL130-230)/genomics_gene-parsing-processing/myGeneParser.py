#!/usr/bin/env python
#Python program that runs through the files in 'YeastGenes' folder and finds the GC content of each sequence and total GC content
# transcribes and finds the %AUGC of the third amino acid in the codon

import fileinput
import os
import os.path
from os import path
import glob

#Reads in seqeunces as elements in list
# header holds the filename in position corresponding to position in sequence
header = list()
sequence = list()

# main program
def main():
    tot_file = 0
    path_foldername = "C:\\Users\\gabsbi\\Desktop\\code-examples\\other\\YeastGenes"
    foldername = 'YeastGenes'
    for filename in os.listdir(path_foldername):
        #print(filename)
        tot_file += 1
        temp = ""
        my_path = path.join(path_foldername, filename)
        for line in fileinput.input(files = (my_path)):
            temp += line
        filename = filename[:-4]
        header.append(filename)
        sequence.append(temp)
        #myFile = open("C:\\Users\\gabsbi\\Desktop\\code-examples\\other\\Yeast_RNAseq\\Nagalakshmi_2008_5UTRs_V64.gff3")
        #print(myFile.name)
        #print(myFile.readlines())
    average = 0
    for i in range(len(sequence)):
        average += gcContent(sequence[i], i)
        transcribe(sequence[i])
        #myFile = open("C:\\Users\\gabsbi\\Desktop\\code-examples\\other\\Yeast_RNAseq\\Nagalakshmi_2008_5UTRs_V64.gff3")
        #print(myFile.name)
        #print(myFile.readlines())
    average /= tot_file
    print("\nAverage GC Content is: ", round(average, 1))
    #myFile = open("C:\\Users\\gabsbi\\Desktop\\code-examples\\other\\Yeast_RNAseq\\Nagalakshmi_2008_5UTRs_V64.gff3")
    #print(myFile.name)
    #print(myFile.readlines())
#Prints sequences below their filename    
def printS():
    for i in range(len(sequence)):
        print(header[i])
        print(sequence[i] + "\n")
        

#Finds GC content 
def gcContent(seq, pos):
    count = 0
    tot = 0
    final = 0
    for i in seq:
        if((i == "C") or (i == "G")):
            count = count + 1
        if((i == "A") or (i == "T")):
            tot = tot + 1
    tot = tot + count
    if(tot !=0):
        final = (count/tot) * 100
    print("\n\nGC content for ", header[pos], "is ", round(final, 1))
    return final

# transcribed sequence to thirdAd()
def transcribe(seq):
    print("\nTranscribing.. \n")
    seq = seq[::-1]
    for i in range(len(seq)):
        if seq[i] == "A":
            seq = seq[:i] + "U" + seq[i+1:]
        elif seq[i] == "T":
            seq = seq[:i] + "A" + seq[i+1:]
        elif seq[i] == "G":
            seq = seq[:i] + "C" + seq[i+1:]
        elif seq[i] == "C":
            seq = seq[:i] + "G" + seq[i+1:]
    thirdAd(seq)

#Finds ratio of AUGC as third amino acid in codon 
def thirdAd(seq):
    Ccount = 0
    Gcount = 0
    Acount = 0
    Ucount = 0
    tot = 0
    for i in range(0, len(seq), 2):
        if seq[i] == "A":
            Acount += 1
            tot += 1
        elif seq[i] == "U":
            Ucount += 1
            tot += 1
        elif seq[i] == "G":
            Gcount += 1
            tot += 1
        elif seq[i] == "C":
            Ccount += 1
            tot += 1
        i += i
    if(tot != 0):
        print("%A at 3rd base ", round(((Acount/tot)*100), 1))
        print("%U at 3rd base ", round(((Ucount/tot)*100), 1))
        print("%G at 3rd base ", round(((Gcount/tot)*100), 1))
        print("%C at 3rd base ", round(((Ccount/tot)*100), 1))
    else:
        print("ERROR: thirdAd is not working correctly")
    


if __name__ == "__main__":
    main()
    #end script
    print ("\nend myGeneParser.py")
    exit
