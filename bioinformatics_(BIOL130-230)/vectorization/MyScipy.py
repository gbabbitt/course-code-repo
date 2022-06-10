import numpy as np
import scipy as sp
import os

def multiplydivide(a,b):
    if a > b:
       return a / b
    else:
       return a * b

vec_multiplydivide = np.vectorize(multiplydivide)
print (vec_multiplydivide([0,3,6,9,9,5,7,3],[1,3,5,7,6,9,2,9]))



print ("exit MyScipy.py\n")

