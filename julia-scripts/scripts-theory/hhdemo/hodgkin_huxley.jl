# The Julia code in this file is ported from the MATLAB code published in 
# Chartier & Johnson (2017). Spike Neural Models Part I: The Hodgkin-Huxley model 
using Plots

function get_gratting_variables(V, V_rest)
   α = (h = 0.07*exp((V_rest-V)/20), 
        m = (2.5-0.1*(V-V_rest))/(exp(2.5-0.1*(V-V_rest))-1), 
        n = (0.1-0.01*(V-V_rest))/(exp(1-0.1*(V-V_rest))-1))
    
   β = (h = 1/(1+exp(3-0.1*(V-V_rest))),
        m =  4*exp((V_rest-V)/18),
        n = 0.125*exp((V_rest-V)/80))
        
    return α, β
end 

function hodgkin_huxley(input_current)
    
    # Initialize values 
    Vrest = 0 # Change this to -65 if required 
    dt = 0.01 # timestep 
    totaltime = 150 # duration of the simulation 
    C = 1 

    # Constants 
    E_Na = 115 +Vrest
    E_K = -6 + Vrest
    E_Leak = 10.6 + Vrest
    
    g_Na = 120
    g_k = 36
    g_Leak = 0.3

    t = 0:dt:totaltime # time verctor 
    I_current = ones(length(t)) .* 0.0 # Current vector 
    I_current[Int(50/dt):end] .= input_current # Input of 3micronA/cm2 beginning at 50ms and steady until end of time

    # Initializing arrays
    (V, m, n, h) = [zeros(length(t)+1) for i in 1:4]
    (G_k, G_Na, I_Na, I_K, I_Leak) = [zeros(length(t)) for i in 1:5]

    # Initializing values 
    V[1] = Vrest
    α, β = get_gratting_variables(V[1], Vrest)

    # Initializing gratting values to asymptotic values 
    m[1] = α.m / (α.m + β.m)
    n[1] = α.n / (α.n + β.n)
    h[1] = α.h / (α.h + β.h)

    for i in 1:length(t)
        α, β = get_gratting_variables(V[i], Vrest)

        # Conductance variables 
        G_k[i] = g_k * n[i]^4
        G_Na[i] = g_Na * (m[i]^3) * h[i]

        # Ionic currents 
        I_Na[i] = G_Na[i] * (V[i] - E_Na)
        I_K[i] = G_k[i] * (V[i] - E_K)
        I_Leak[i] = g_Leak * (V[i] - E_Leak)

        Input = I_current[i] - (I_Na[i] + I_K[i] + I_Leak[i])

        # Calculating the new membrane potential 
        V[i+1] = V[i] + Input * dt * 1/C
    
        m[i+1] = m[i] + (α.m * (1-m[i]) - β.m * m[i]) * dt
        n[i+1] = n[i] + (α.n * (1-n[i]) - β.n * n[i]) * dt 
        h[i+1] = h[i] + (α.h * (1-h[i]) - β.h * h[i]) * dt  
    end 
    params = (V=V, m=m, n=n, h=h, G_k = G_k, G_Na =G_Na, I_K = I_K,I_Leak = I_Leak,t,dt, I_current)
    return  params
end

function generate_plots(input_current)
    params = hodgkin_huxley(input_current)
    xstart = Int(45/params.dt)
    time = params.t[xstart:end]
    display_gratting = plot(time,params.m[xstart:end-1],
                            xlabel = "Time (ms)", title = "Grating Parameters", label="m") 
    plot!(display_gratting, time, params.n[xstart:end-1], label ="n")
    plot!(display_gratting, time, params.h[xstart:end-1], label ="h")

    display_actionP = plot(time, params.V[xstart:end-1], xlabel = "Time (ms)", ylabel = "Voltage (mV)",
                        title="Action Potential", label="", ylims=[-1,110])
    
    display_input = plot(time,params.I_current[xstart:end], xlabel = "Time (ms)", ylabel = "μA/cm²",
                            title = "Input", label="", ylims = [0,10])

    display_conductance = plot(time,params.G_Na[xstart:end], xlabel="Time (ms)", ylabel = "Voltage (mV)",
                            title = "Conduction of K⁺ and Na⁺", label = "Na⁺")
    plot!(display_conductance, time, params.G_k[xstart:end],label = "K⁺")
    
    final_plot = plot(display_gratting, display_input, display_actionP, display_conductance, layout=@layout[a;b c;d], size =(700,600))
end