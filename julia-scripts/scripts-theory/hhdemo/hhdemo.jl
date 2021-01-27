### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ fe9f9510-6055-11eb-2064-fb0d68f76e64
using PlutoUI

# ╔═╡ b7178270-6055-11eb-1d9d-1558690fb171
include("hodgkin_huxley.jl")

# ╔═╡ 3630e4c0-6056-11eb-3ab8-9d5c27ca9099
@bind input_current Slider(0:0.01:10, default=2)

# ╔═╡ 7f15a132-6056-11eb-1f09-8d04fefe528b
generate_plots(input_current)

# ╔═╡ aee4424e-605a-11eb-1b67-09c0df2fe9a0
input_current 

# ╔═╡ Cell order:
# ╠═b7178270-6055-11eb-1d9d-1558690fb171
# ╠═fe9f9510-6055-11eb-2064-fb0d68f76e64
# ╠═3630e4c0-6056-11eb-3ab8-9d5c27ca9099
# ╠═7f15a132-6056-11eb-1f09-8d04fefe528b
# ╠═aee4424e-605a-11eb-1b67-09c0df2fe9a0
