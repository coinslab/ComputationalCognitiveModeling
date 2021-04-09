using Statistics
using RDatasets
data = dataset("datasets", "iris")

# Summary Statistics 
describe(data)

# Unique elements in Species
unique(data.Species)
# Standard Deviation of PetalWidth
std(data.PetalWidth)

# Variance of  PetalWidth
var(data.PetalWidth)

#Mean of PetalWidth 
mean(data.PetalWidth)

#Median of PetalWidth
median(data.PetalWidth)

#Correlation between PetalWidth & PetalLength
cor(data.PetalWidth, data.PetalLength)
