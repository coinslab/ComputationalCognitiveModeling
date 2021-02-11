using  Plots
function euler(x₀, δ_t,nrsteps)
    x = x₀
    for i in 1:nrsteps
        dxdt = (x-3)*(x+6)*x
        x = x+ δ_t * dxdt
    end
    return x
end

# Each function should only have one task to do
function eulerarray(x0, deltat,nrsteps)
    x = Float64[] # Initialize an empty array
    append!(x, x0)
    for i in 1:nrsteps
        dxdt = (x[i] - 3) * (x[i] + 6) * x[i]
        temp = x[i] + deltat * dxdt
        append!(x,temp)
    end
    return x
end
"""
Demo function for Euler method
    - returns a plot
"""
function eulerarraydemo(x0,deltat,nrsteps)
    x = eulerarray(x0,deltat,nrsteps)
    plot(x, xlabel = "Time t", ylabel = "x",
            title = "Euler Example",
            legend=false)
end

function demo()
    println("x0? :")
    x0 = chomp(readline())
    x0 = parse(Float64,x0)
    println("delta? :")
    delta = chomp(readline())
    delta = parse(Float64,delta)
    println("n: ?")
    n = chomp(readline())
    n = parse(Int,n)
    eulerarraydemo(x0,delta,n)
end

println("Call demo() for an interactive session")
#demo()
#savefig(plot,"eulertest.png")
