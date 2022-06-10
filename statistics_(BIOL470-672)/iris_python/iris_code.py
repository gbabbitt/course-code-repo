# Code source: Gaël Varoquaux
# Modified for documentation by Jaques Grobler
# modified for teaching examples by Greg Babbitt
# License: BSD 3 clause

import matplotlib.pyplot as plt
import pandas as pd
from sklearn import datasets
import statsmodels.api as sm
from statsmodels.formula.api import ols
# NOTE: to install python modules, use pip or pip3 installer on the command line (e.g. pip install ModuleName)

# import some data to play with
iris_internal = datasets.load_iris()
X = iris_internal.data[:, :2]  # we only take the first two features.
y = iris_internal.target
#print(iris_internal)
#print(X)
#print(y)

# import from external file
# without pandas
infile = open("iris_tab.txt", "r")
iris_external = infile.readlines()
#print(iris_external)

# with pandas...create dataframe
iris_data = pd.read_csv("iris_tab.txt", sep='\t') 
# NOTE: In Win full path is not needed if data file is in same folder as code script
# NOTE: In Linux, full path is always needed
# NOTE: full path in Win is C:/Users/username/Desktop/folder/filename
# NOTE: full path in Linux/Mac is /home/username/Desktop/folder/filename
print(iris_data)
species_label = iris_data.species
petal_length = iris_data.petal_length
petal_width = iris_data.petal_width
sepal_length = iris_data.sepal_length
sepal_width = iris_data.sepal_width
flower_size = (petal_length + petal_width + sepal_length + sepal_width)/4
#print(petal_length)
#print(species)

iris_data_integer = pd.read_csv("iris_tab_integer.txt", sep='\t')
print(iris_data_integer)
species_factor = iris_data_integer.species

# creating a copy of the original data frame for dummy variables
iris_data_dummy = iris_data.copy()
  
# calling the get_dummies method
# the first parameter mentions the the name of the data frame to store the new data frame in
# the second parameter is the list of columns which if not mentioned returns the dummies for all categorical columns
iris_data_dummy = pd.get_dummies(iris_data_dummy)
print(iris_data_dummy)


def main_internal():
        
    x_min, x_max = X[:, 0].min() - 0.5, X[:, 0].max() + 0.5
    y_min, y_max = X[:, 1].min() - 0.5, X[:, 1].max() + 0.5

    plt.figure(1, figsize=(8, 6))
    plt.clf()

    # Plot the training points
    plt.scatter(X[:, 0], X[:, 1], c=y, cmap=plt.cm.Set1, edgecolor="k")
    plt.xlabel("Sepal length")
    plt.ylabel("Sepal width")

    plt.xlim(x_min, x_max)
    plt.ylim(y_min, y_max)
    plt.xticks(())
    plt.yticks(())

    plt.show()



def main_external():
    
    # scatter plot petals  
    plt.figure(1, figsize=(8, 6))
    plt.clf()

    plt.scatter(petal_length, petal_width, c=species_factor, cmap=plt.cm.Set2, edgecolor="k")
    plt.xlabel("petal length")
    plt.ylabel("petal width")
    plt.xticks(())
    plt.yticks(())

    plt.show()
    
    # scatter plot sepals  
    plt.figure(2, figsize=(8, 6))
    plt.clf()

    plt.scatter(sepal_length, sepal_width, c=species_factor, cmap=plt.cm.Set2, edgecolor="k")
    plt.xlabel("Sepal length")
    plt.ylabel("Sepal width")
    plt.xticks(())
    plt.yticks(())
    
    plt.show()

    # scatter plot sepals  
    plt.figure(3, figsize=(8, 6))
    plt.clf()

    plt.bar(species_label, flower_size)
    plt.xlabel("Species")
    plt.ylabel("Flower Size")
    plt.xticks(())
    plt.yticks(())

    plt.show()
    
    # one way ANOVA example
    model = ols('petal_length ~ C(species)', data=iris_data).fit()
    aov_table = sm.stats.anova_lm(model, typ=2)
    print(aov_table)
    model = ols('petal_width ~ C(species)', data=iris_data).fit()
    aov_table = sm.stats.anova_lm(model, typ=2)
    print(aov_table)
    model = ols('sepal_length ~ C(species)', data=iris_data).fit()
    aov_table = sm.stats.anova_lm(model, typ=2)
    print(aov_table)
    model = ols('sepal_width ~ C(species)', data=iris_data).fit()
    aov_table = sm.stats.anova_lm(model, typ=2)
    print(aov_table)
    model = ols('flower_size ~ C(species)', data=iris_data).fit()
    aov_table = sm.stats.anova_lm(model, typ=2)
    print(aov_table)

    
    
if __name__ == '__main__':
    main_internal()
    main_external()