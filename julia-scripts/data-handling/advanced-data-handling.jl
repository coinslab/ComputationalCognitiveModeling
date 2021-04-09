using Plots
using StatsPlots
using RDatasets
using StatsBase
using DataFrames
using DataFramesMeta
cars = dataset("datasets", "mtcars")

describe(cars)

# Splitting by engine type 
# AND 
@linq where(:Cyl .== 4, :Gear .== 5)(cars)

@linq where(.|(:Cyl .== 4, :Cyl .== 6))(cars)
@linq where(:Model .== "Honda Civic")(cars)

@linq select(:Model, :MPG)(where(:Cyl .!= 4)(cars))

@linq orderby(:MPG)(select(:Model, :MPG)(where(:Cyl .== 4)(cars)))

@linq orderby(-:MPG)(select(:Model, :MPG)(where(:Cyl .== 4)(cars)))

@linq by(:Cyl; meanMPG=mean(:MPG))(transform(; KPL=:MPG .* 0.425144)(cars))

unstack(cars, :Model, :Cyl, :MPG)
