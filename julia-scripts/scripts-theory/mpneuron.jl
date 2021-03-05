
function mpneuron(X,W)
    ψ = sum(X .* W) 
    if ψ >0
        return 1
    else
        return 0
    end
end


