using Flux
# Demo for Perceptron =====================================================
function Perceptron(units)
    ϕ(x) = x >= 0 ? 1 : -1       # Stimulus  
    Chain(
    Dense(3,units, ϕ),           # Hidden Layer 
    Dense(units,1, x-> ϕ.(x)))   # Output Layer 
end

function demoperceptron(lr,epochs, units, X,y)
    # Setting the strategy for learning 
    opt = Descent(lr) 

    # Defining a 1 Laye Perceptron with `units` no of nodes 
    model = Perceptron(units)

    # Defining the loss function 
    loss(x, y) = sum(Flux.Losses.logitbinarycrossentropy(model(X'), y))
    
    # Model Training ==========================
    ps = Flux.params(model)                   # 
    for i in 1:epochs                         #
        Flux.train!(loss, ps,zip(X',y), opt)  #
    end                                       #
    # =========================================
    return model 
end

println("""
How to run demoperceptron (an example) ?
=========================================

learning_rate = 1.0
learning_trials = 50
hidden_units = 10

X = [-1 -1 1;
     -1 1 1;
     1 -1 1;
     1 1 1]

R = [1 -1 -1 1]
model = demoperceptron(learning_rate, learning_trials,
                        hidden_units, X, R)
W = params(m)[1]  
V = params(m)[2]
""")