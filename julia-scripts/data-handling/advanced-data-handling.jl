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
@linq cars |>
        where(:Cyl .==4, :Gear .==5)

@linq cars |>
        where( .|(:Cyl .==4, :Cyl .==6))
@linq cars |>
        where(:Model .== "Honda Civic")
        

@linq cars |>
        where(:Cyl .!=4) |>
        select(:Model, :MPG)          

@linq cars |>
        where(:Cyl .==4) |>
        select(:Model, :MPG) |>
        orderby(:MPG) 


@linq cars |>
        where(:Cyl .==4) |>
        select(:Model, :MPG) |>
        orderby(-:MPG)

@linq cars |>
        transform(KPL = :MPG .* 0.425144) |>
        by(:Cyl, meanMPG = mean(:MPG))

    
unstack(cars,:Model,:Cyl,:MPG)
