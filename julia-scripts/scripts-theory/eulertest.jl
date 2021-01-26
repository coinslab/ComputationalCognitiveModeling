using Plots
function euler(x₀, δ_t, nrsteps)
    x = x₀
    for i in 1:nrsteps
        dxdt = (x - 3) * (x + 6) * x
        x = x + δ_t * dxdt
    end
    return x
end

function eulerarray(x0, deltat, nrsteps)
    x = Float64[] # Initialize an empty array
    append!(x, x0)
    for i in 1:nrsteps
        dxdt = (x[i] - 3) * (x[i] + 6) * x[i]
        temp = x[i] + deltat * dxdt
        append!(x, temp)
    end
    plot(x, 
        xlabel="time", 
         ylabel="x array",
         title="Euler Example", legend=false)
end