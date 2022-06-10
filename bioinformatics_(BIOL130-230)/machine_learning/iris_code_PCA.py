# Code source: Gaël Varoquaux
# Modified for documentation by Jaques Grobler
# modified for teaching examples by Greg Babbitt
# License: BSD 3 clause

import matplotlib.pyplot as plt
import pandas as pd
from sklearn import datasets
import statsmodels.api as sm
from statsmodels.formula.api import ols
from sklearn.preprocessing import StandardScaler
from sklearn.decomposition import PCA
from sklearn import datasets # gets iris data set
from yellowbrick.features import PCA as PCA_alt

# import from external file
# without pandas
infile = open("iris_tab.txt", "r")
iris_external = infile.readlines()
#print(iris_external)

# with pandas...create dataframe
iris_data = pd.read_csv("iris_tab.txt", sep='\t')
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
#species_factor = pd.DataFrame(species_factor)

# set up features for PCA 
features = [sepal_length, sepal_width, petal_length, petal_width]



def plot_untransformed_data():
    
    # scatter plot petals  
    plt.figure(1, figsize=(8, 6))
    plt.clf()

    plt.scatter(petal_length, petal_width, c=species_factor, cmap=plt.cm.Set1, edgecolor="k")
    plt.xlabel("petal length")
    plt.ylabel("petal width")
    plt.xticks(())
    plt.yticks(())

    plt.show()
    
    # scatter plot sepals  
    plt.figure(2, figsize=(8, 6))
    plt.clf()

    plt.scatter(sepal_length, sepal_width, c=species_factor, cmap=plt.cm.Set1, edgecolor="k")
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
    
def transform_analyze():
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

    # run PCA and plot
    pca = PCA(n_components=4)
    principalComponents = pca.fit_transform(features)
    principalDf = pd.DataFrame(data = principalComponents, columns = ['principal component 1', 'principal component 2', 'principal component 3', 'principal component 4'])
    #finalDf = pd.concat([principalDf, df[['target']]], axis = 1)
    print('\n')
    print(principalComponents) # as matrix
    print (principalDf) # as data frame
    explained_variance=pca.explained_variance_ratio_
    print(explained_variance)
    # scree plot
    with plt.style.context('dark_background'):
        plt.figure(figsize=(6, 4))
        plt.bar(range(4), explained_variance, alpha=0.5, align='center', label='individual explained variance')
        plt.ylabel('Explained variance ratio')
        plt.xlabel('Principal components')
        plt.legend(loc='best')
        plt.tight_layout()
        plt.show()
       
    # To getter a better understanding of interaction of the dimensions
    # plot the PCA dimensions using function from yellowbrick
    iris = datasets.load_iris()  # note...this plot is no longer reading imported data
    X = iris.data
    y = iris.target
    #print(X)
    #print(y)
    visualizer = PCA_alt(scale=True, proj_features=True, projection=3)
    visualizer.fit_transform(X, y)
    visualizer.show()
    #visualizer.show(outpath='iris_comps.png')
      
def main():   
    plot_untransformed_data()
    transform_analyze()
    
    
if __name__ == '__main__':
    main()