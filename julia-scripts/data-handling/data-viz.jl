using Plots 
using StatsPlots
using RDatasets
using DataFrames
data = dataset("datasets", "iris")

# AN IMAGE IS WORTH THOUSAND WORDS 
names(data)
histogram(data.SepalLength,   
    xlabel="SepalLength", ylabel="Frequency", 
    linewidth=0.2, palette= :seaborn_deep, 
    grid=false,label="")


histogram(data.SepalWidth,   
    xlabel="SepalWidth", ylabel="Frequency", 
    linewidth=0.2, palette= :seaborn_deep, 
    grid=false,label="")


histogram(data.PetalWidth,   
    xlabel="PetallWidth", ylabel="Frequency", 
    linewidth=0.2, palette= :seaborn_deep, 
    grid=false,label="")


groupedhist(data.PetalWidth, 
    group = data.Species, 
    xlabel = "PetallWidth", ylabel ="Frequency",
     bar_position = :stack, palette= :seaborn_deep, linewidth=0.2)


histogram(data.PetalLength,    
    xlabel="PetalLength", ylabel="Frequency", 
    linewidth=0.2, palette= :seaborn_deep, 
    grid=false,label="")


groupedhist(data.PetalLength, 
    group = data.Species, 
    xlabel = "PetalLength", ylabel ="Frequency",
     bar_position = :stack, palette= :seaborn_deep, linewidth=0.2)


# ==============================

scatter(data.SepalLength, data.SepalWidth,
    xlabel="SepalLength", ylabel="SepalWidth", grid=false, label="", 
    palette= :seaborn_deep)


scatter(data.SepalLength, data.SepalWidth,
    group=data.Species,
    xlabel="SepalLength", ylabel="SepalWidth", grid=false, 
    palette= :seaborn_deep)


scatter(data.PetalLength, data.PetalWidth,
    xlabel="PetalLength", ylabel="PetallWidth", grid=false, label="", 
    palette= :seaborn_deep)


scatter(data.PetalLength, data.PetalWidth,
    xlabel="PetalLength", ylabel="PetalWidth", grid=false, label="",
    group=data.Species, 
    palette= :seaborn_deep)

 
cornerplot(Array(data[!,1:4]), label=names(data[!,1:4]),
                size=(1000,1000), compact=true)


groupedhist(data.SepalLength, group = data.Species, bar_position = :stack)
groupedhist(data.PetalWidth, group = data.Species, bar_position = :stack, palette= :seaborn_deep)

bar([countmap(data.Species)[x] for x in unique(data.Species)],
 xticks=(1:3, s), palette= :seaborn_deep, label="")
