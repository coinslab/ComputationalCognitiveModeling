# To download data from a url, use the below code 

url = "https://gist.githubusercontent.com/curran/a08a1080b88344b0c8a7/raw/0e7a9b0a5d22642a06d3d5b9bcbad9890c8ee534/iris.csv"
dataname = "iris.csv" # Here you can give any name you wish instead of iris 
download(url, dataname)
# =================================================

# To load CSV Files from your working directory 
using CSV # This is a pacakge we use for loading CSV Files.
using DataFrames
data = CSV.read("iris.csv", DataFrame) # This will load the dataset and convert it into a DataFrame
# =================================================

# To load it from Packages like RDatasets
using RDatasets
data = dataset("datasets", "iris")
# =================================================
