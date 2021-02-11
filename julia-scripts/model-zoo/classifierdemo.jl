### A Pluto.jl notebook ###
# v0.12.20

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

# ╔═╡ e16d5b2e-6361-11eb-3766-8b163c393ce7
using PlutoUI

# ╔═╡ 8c5bc2d0-6366-11eb-28bd-c335be197923
using ScikitLearn

# ╔═╡ 6c488620-635e-11eb-31ba-e11945ef7055
include("classifiers.jl")

# ╔═╡ 17d37150-6362-11eb-3516-43ed8dadcd21
names(datawithoutmissing)

# ╔═╡ be4fa400-6361-11eb-0237-c7f346aff057
md"""
# COVID Risk Analyzer App
**Intubed?:** $(@bind intubed Select(["0" => "Yes", "1" => "No"]))

**Have Pneumonia?:** $(@bind pneumonia Select(["0" => "Yes", "1" => "No"]))

**Age:** $(@bind age TextField(default="20"))

**Pregnant?:** $(@bind pregnant Select(["0" => "Yes", "1" => "No"]))

**Diabetic?:** $(@bind diabetic Select(["0" => "Yes", "1" => "No"]))

**Have Chronic Obstructive Pulmonary Disease?:** $(@bind copd Select(["0" => "Yes", "1" => "No"]))

**Have Asthma?:** $(@bind asthma Select(["0" => "Yes", "1" => "No"]))

**Immunosuppressed?:** $(@bind inmsupr Select(["0" => "Yes", "1" => "No"]))

**Hypertension?:** $(@bind hypertension Select(["0" => "Yes", "1" => "No"]))

**Have other diseases?:** $(@bind other_disease Select(["0" => "Yes", "1" => "No"]))

**Have Cardiovascular diseases?:** $(@bind cardiovascular Select(["0" => "Yes", "1" => "No"]))

**Obese?:** $(@bind obesity Select(["0" => "Yes", "1" => "No"]))

**Chronic Renal Disease?:** $(@bind renal_chronic Select(["0" => "Yes", "1" => "No"]))

**Smoker?:** $(@bind tobacco Select(["0" => "Yes", "1" => "No"]))

**Came in contact with COVID patient?:** $(@bind contact_other_covid Select(["0" => "Yes", "1" => "No"]))

"""

# ╔═╡ 98a0e810-6369-11eb-300e-bf80f1c9e8db
@bind go Button("Analyze")

# ╔═╡ 0f549420-6365-11eb-12ee-2d14ffe1de96
let 
	go 
	input = parse.(Int,[intubed, pneumonia,age,pregnant,diabetic,copd,asthma,inmsupr,hypertension,other_disease,cardiovascular,obesity,renal_chronic,tobacco,contact_other_covid])
	md"""$(get_prediction(input))"""
end

# ╔═╡ 7ae6bcf2-6369-11eb-317c-772ddd065e0a


# ╔═╡ Cell order:
# ╠═e16d5b2e-6361-11eb-3766-8b163c393ce7
# ╠═8c5bc2d0-6366-11eb-28bd-c335be197923
# ╠═6c488620-635e-11eb-31ba-e11945ef7055
# ╠═17d37150-6362-11eb-3516-43ed8dadcd21
# ╟─be4fa400-6361-11eb-0237-c7f346aff057
# ╟─98a0e810-6369-11eb-300e-bf80f1c9e8db
# ╟─0f549420-6365-11eb-12ee-2d14ffe1de96
# ╠═7ae6bcf2-6369-11eb-317c-772ddd065e0a
