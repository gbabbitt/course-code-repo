
# Packages
using CSV, DelimitedFiles, DataFrames, Queryverse, PlutoUI, Combinatorics
using GLM, ANOVA
using RDatasets  # NOTE: can't use RDatasets and PlotyJS at same time
#using PlotlyJS
using Plots # NOTE: can't use Plots and PlotlyJS at the same time
#using StatsPlots NOTE: this is deprecated as of 2020 but we can use Plots or PlotlyJS instead

###############################################################################
# NOTE to install packages for first time enter julia interpreter and type
#    import Pkg; Pkg.add("PackageName")
# to enter interpreter type 'julia' to exit type 'exit()'
# to enter >pkg (the julia package manager) type ']' and '^c' to escape
# to update packages '>pkg update' OR 'pkg> update PackageName'  (rm will remove packages)
################################################################################

println("Hello from Julia")

# paths to the data files
pathCSV = "C:\\Users\\gabsbi\\Desktop\\code-examples\\iris_julia\\iris_csv.data"
pathTAB = "C:\\Users\\gabsbi\\Desktop\\code-examples\\iris_julia\\iris_tab.txt"
pathINT = "C:\\Users\\gabsbi\\Desktop\\code-examples\\iris_julia\\iris_tab_integer.txt"

# open and read tab delimited data file line by line
open(pathTAB, "r") do f
    for (i, ln) in enumerate(eachline(f))
        #println("$i $ln")
    end
end

# example for readdlm90 function on tab delimited .txt
#iris_data = readdlm(pathTAB, header=true)
#print(iris_data)

# 2 ways to create data frames in julia
# create data frame by passing data to it
df_tab = DataFrame(CSV.File(pathTAB))
print(first(df_tab, 10)) # note in julia first and last replace head and tail in R/python 
#print(last(df_tab, 10))
print("\n")

# create data frame with species as interger values
df_int = DataFrame(CSV.File(pathINT))
print(first(df_int, 10)) # note in julia first and last replace head and tail in R/python 
#print(last(df_int, 10))
print("\n")

# create data frame by piping data into it
df_csv = CSV.File(pathCSV) |> DataFrame
print(first(df_csv, 10)) 
#print(last(df_csv, 10))
print("\n")

# using built-in R datasets
#using RDatasets
#Riris = dataset("datasets", "iris")
#print(first(Riris, 10))

# print single column using column header label
print("\n")
print(df_tab.species)
print(df_int.species)
print("\n")

# analyze ANOVA with julia function/package using R data set
data = dataset("datasets", "iris")
categorical!(data, :Species)

model = fit(LinearModel,
            @formula(PetalLength ~  Species),
            data,
            contrasts = Dict(:Species => EffectsCoding()))
print(model)
myAnova1 = anova(model)
print(myAnova1)

# analyze ANOVA with julia function/package using data frame from imported data
categorical!(df_tab, :species)

model = fit(LinearModel,
            @formula(petal_length ~  species),
            df_tab,
            contrasts = Dict(:species => EffectsCoding()))
print(model)
myAnova2 = anova(model)
print(myAnova2)


#### analyze ANOVA with embedded python code (note: much easier to setup in Linux) ####
#using PyCall
#py"""
#iris_data = pd.read_csv("iris_tab.txt", sep='\t') 
#print(iris_data)
#species_label = iris_data.species
#petal_length = iris_data.petal_length
#petal_width = iris_data.petal_width
#sepal_length = iris_data.sepal_length
#sepal_width = iris_data.sepal_width
#model = ols('petal_length ~ C(species)', data=iris_data).fit()
#aov_table = sm.stats.anova_lm(model, typ=2)
#print(aov_table)
#"""

#### analyze ANOVA with embedded R code (much easier to setup in Linux) ####
#using RCall
#R"""
#data<-read.table("C:/Users/gabsbi/Desktop/code-examples/R/iris_tab.txt",header=TRUE)
#sepal_length=data$sepal_length
#sepal_width=data$sepal_width
#petal_length=data$petal_length
#petal_width=data$petal_width
#species=data$species
#iris.data<-data.frame(sepal_length, sepal_width, petal_length, petal_width, species)
#print(iris.data)
#print(summary(iris.data))
#petal_length.anova <- oneway.test(petal_length~species) 
#petal_width.anova <- oneway.test(petal_width~species)
#sepal_length.anova <- oneway.test(sepal_length~species) 
#sepal_width.anova <- oneway.test(sepal_width~species)
#print(sepal_length.anova)
#print(sepal_width.anova)
#print(petal_length.anova)
#print(petal_width.anova)
#"""

# write and sink terminal output to a text file
open("myAnova.txt", "w") do io
    write(io, "HERE IS TERMINAL OUTPUT FROM MY FANCY CODE\n")
    redirect_stdout(io) do
        print(model)    
        print(myAnova1)
        print(myAnova2)
    end
end

# make multipanel plot with Plots.jl
x1 = df_tab.petal_length; y1 = df_tab.petal_width 
x2 = df_tab.sepal_length; y2 = df_tab.sepal_width
SPtype = df_int.species
p1 = plot(x1, y1, color=SPtype) # Make a line plot
p2 = scatter(x1, y1, color=SPtype, xlabel="Petal Length", ylabel="Petal Width") # Make a scatter plot
p3 = plot(x2, y2, color=SPtype, title="IRIS FLOWERS")
p4 = scatter(x2, y2, color=SPtype, xlabel="Sepal Length", ylabel="Sepal Width")
myPlot = plot(p1, p2, p3, p4, layout=(2, 2), legend=false)
savefig(myPlot,"multipanel_example.png")
display(myPlot) # to open plot

# make some better plots with StatsPlots.jl (for full potential see StatsPlots https://docs.juliaplots.org/stable/)
# load a dataset
#iris = dataset("datasets", "iris");
#@df iris scatter(
#    :SepalLength,
#    :SepalWidth,
#    group = :Species,
#    title = "My awesome plot",
#    xlabel = "Length",
#    ylabel = "Width",
#    m = (0.5, [:cross :hex :star7], 12),
#    bg = RGB(0.2, 0.2, 0.2)
#)


#using RDatasets, StatsPlots
#iris = dataset("datasets", "iris")
#@df iris marginalhist(:PetalLength, :PetalWidth)