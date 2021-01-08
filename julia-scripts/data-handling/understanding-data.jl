using RDatasets 
data = dataset("datasets", "iris")
first(data,4)

typeof(data)

array_data = convert(Array,data)
typeof(array_data)

matrix_data = convert(Matrix,data[!,1:4])
typeof(matrix_data)

data[!, 1:4] # Choosing columns 
data[1:3,1] # Choosing rows 

names(data)

# Accessing colums several ways 
data.Species
data[!,:Species]
data[!,[:Species, :SepalLength]]
unique(data[!,:Species])
levels(data[!, :Species]) # For categorical


