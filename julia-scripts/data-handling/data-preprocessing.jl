using ScikitLearn
using RDatasets
using CSV
using DataFrames
using MLLabelUtils
using StatsBase: standardize, mean
@sk_import model_selection: train_test_split 
@sk_import preprocessing: OneHotEncoder
iris = dataset("datasets", "iris")

# If you want to use ScikitLearn, you need to convert DataFrames to Arrays 
# ScikitLearn only accepts data as arrays. 
X = convert(Array,iris[!, 1:4])
y = convert(Array,iris[!,5])

# train_test_split is a function from ScikitLearn, and splits the data 
# according to the value passed to test_size. Here we are saying
# that we need to allocate 33% of the raw data as test data 
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)

data = dataset("datasets", "airquality")
describe(data)
describe(dropmissing(data))

dropmissing!(data) # <- this will permananty change the data by dropping missing values 

data = dataset("datasets", "airquality") # re-loading because we need a fresh copy of the data for next e.g.
# In some other cases, you just want to replace the missing values with the mean of the data or with 0.
# In those cases you can use coalesce function from julia's base library 

# To replace the missing values with 0
data.Ozone = coalesce.(data.Ozone, 0)
# Let's check the data once again 
describe(data)

# For Solar.R let's replace it with the mean 
data."Solar.R" = coalesce.(data."Solar.R", mean(skipmissing(data."Solar.R")))
describe(data)

standardize(UnitRangeTransform, X, dims=1)
standardize(ZScoreTransform, X, dims=1, center=false, scale=true)

onehotencoded = convertlabel(LabelEnc.OneOfK{Float32}, y, obsdim=1)