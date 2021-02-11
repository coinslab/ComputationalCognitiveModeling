# Learning Rules. 
# We are creating new data types here to hold each learning rule as a concept. 
struct hebb end 
struct hebbdecay end 
struct oja end 
struct willshaw end 
struct antihebbdecay end 

# Implementing different learning methods for different learning rule 
# Here we are making use of the multiple dispatch feature in Julia 
# Multiple Dispatch provides an unified framework for implementing different methods
learning(X,W,γ,r, rule::hebb;δ) = W + (γ .* X .* r)
learning(X,W,γ,r,rule::hebbdecay;δ) = W + (γ .* X .* r) - (γ .* δ .* W)
learning(X,W,γ,r,rule::oja;δ) = W + (γ .* X .* r) - (γ .* r^2 .* W)
learning(X,W,γ,r,rule::willshaw;δ) = W + (γ .* X .* r) .* (X .- W)
learning(X,W,γ,r,rule::antihebbdecay;δ) = W - (γ .* X .* r) - (γ * δ .* (W .- 1))


"""
USAGE: 

`hebbianlearn(X,W,b, γ, r, hebb())` for hebbian learning \n
`hebbianlearn(X,W,b, γ, r, hebbdecay(), δ = delata_val)` for hebbian decay learning rule \n
`hebbianlearn(X,W,b, γ, r, oja(), δ = delata_val)` for oja learning rule \n
`hebbianlearn(X,W,b, γ, r, willshaw(), δ = delata_val)` for willshaw learning rule \n
`hebbianlearn(X,W,b, γ, r, antihebbdecay(), δ = delata_val)` for antihebbdecay learning rule 

"""
function hebbianlearn(X, W, b, γ, r, rule;δ=0)
    Wb = [W b]
    Xnew = [X ones(size(X,1))]
    Wb = learning(Xnew,Wb, γ,r,rule, δ=δ)
    return Wb[:,1:size(W,2)], Wb[:,size(W,2)+1] # Unpacking W and b from Wb 
end
