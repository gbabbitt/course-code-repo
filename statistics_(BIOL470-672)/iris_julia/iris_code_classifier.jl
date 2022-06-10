
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

######### train and deploy a neural network (requires GPU) #######
# get data and clean it
csv_data = CSV.File(pathCSV, header=false)

    iris_names = ["sepal_len", "sepal_wid", "petal_len", "petal_wid", "class"]
    df = DataFrame(csv_data.columns, Symbol.(iris_names))
    dropmissing!(df)
# define 3 species classes
df_species = groupby(df, :class)
# Get all combinations of colums
combins = collect(combinations(1:4,2))
combos = [(df[x][1], df[x][2]) for x in combins]
# Plot all combinations in sub-plots
myComboPlot = scatter(combos, layout=(2,3))
savefig(myComboPlot, "iris_combinations.png")
# deep learning imports
Pkg.add("Flux")
Pkg.add("CUDA")
Pkg.add("IterTools")
using Flux
using Flux: Data.DataLoader
using Flux: @epochs
using CUDA
using Random
using IterTools: ncycle
Random.seed!(123);
# setup testing data set
# Convert df to array
data = convert(Array, df)

# Shuffle
data = data[shuffle(1:end), :]

# train/test split
train_test_ratio = .7
idx = Int(floor(size(df, 1) * train_test_ratio))
data_train = data[1:idx,:]
data_test = data[idx+1:end, :]

# Get feature vectors
get_feat(d) = transpose(convert(Array{Float32},d[:, 1:end-1]))
x_train = get_feat(data_train)
x_test = get_feat(data_test)

# One hot labels
#   onehot(d) = [Flux.onehot(v, unique(df.class)) for v in d[:,end]]
onehot(d) = Flux.onehotbatch(d[:,end], unique(df.class))
y_train = onehot(data_train)
y_test = onehot(data_test)

# create data loaders for batches
batch_size= 1
train_dl = DataLoader((x_train, y_train), batchsize=batch_size, shuffle=true)
test_dl = DataLoader((x_test, y_test), batchsize=batch_size)

# build neural network
### Model ----------------------------
function get_model()
    c = Chain(
        Dense(4,8,relu),
        Dense(8,3),
        softmax
    )
end

model = get_model()

### Loss ------------------------------
loss(x,y) = Flux.Losses.logitbinarycrossentropy(model(x), y)

train_losses = []
test_losses = []
train_acces = []
test_acces = []

### Optimiser ------------------------------
lr = 0.001
opt = ADAM(lr, (0.9, 0.999))

### Callbacks ------------------------------
function loss_all(data_loader)
    sum([loss(x, y) for (x,y) in data_loader]) / length(data_loader) 
end

function acc(data_loader)
    f(x) = Flux.onecold(cpu(x))
    acces = [sum(f(model(x)) .== f(y)) / size(x,2)  for (x,y) in data_loader]
    sum(acces) / length(data_loader)
end

callbacks = [
    () -> push!(train_losses, loss_all(train_dl)),
    () -> push!(test_losses, loss_all(test_dl)),
    () -> push!(train_acces, acc(train_dl)),
    () -> push!(test_acces, acc(test_dl)),
]

# Training ------------------------------
epochs = 30
ps = Flux.params(model)

@epochs epochs Flux.train!(loss, ps, train_dl, opt, cb = callbacks)

@show train_loss = loss_all(train_dl)
@show test_loss = loss_all(test_dl)
@show train_acc = acc(train_dl)
@show test_acc = acc(test_dl)

# run one example of a prediction through the trained model
y = (y_test[:,1])
pred = (model(x_test[:,1]))
print(pred)

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