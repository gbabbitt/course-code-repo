#!/usr/bin/env python
import os

def main():
   print("running my R script 'iris_code.R'\n") 
   #sleep(1)
   cmd = 'Rscript iris_code.R'
   os.system(cmd)
   print('end script\n')

if __name__ == '__main__':
    main()
