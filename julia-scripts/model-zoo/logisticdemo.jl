### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ 4dd67540-6696-11eb-313d-49aaec40c97b
using ScikitLearn

# ╔═╡ 07836df0-669b-11eb-36e1-c7a130d62f2a
using Statistics

# ╔═╡ ba206ea0-6695-11eb-0046-77b8e1fcd083
begin 
	using PlutoUI
	using CSV # This is a pacakge we use for loading CSV Files.
	using DataFrames;
	@sk_import model_selection: train_test_split;
	@sk_import linear_model: LogisticRegression;
	@sk_import metrics: confusion_matrix;
	@sk_import metrics: classification_report;
	@sk_import model_selection: cross_val_score;
	@sk_import metrics: plot_confusion_matrix;
	pathtodata = joinpath("covid_cleaned.csv");
	data = CSV.read(pathtodata, DataFrame);
end

# ╔═╡ bce85980-669b-11eb-0ce0-051cccead17d
using PyPlot

# ╔═╡ 84be3e80-6696-11eb-1c2d-695ff4573f91
md"""
The dataset looks like this 👇. By clicking on the `more` button in the table you can see more rows and columns of the data"""

# ╔═╡ 751bd5c0-6699-11eb-1ea5-51bcfdab90a1
md""" ### Our Dataset"""

# ╔═╡ 74483970-6696-11eb-0da7-2fa268ef4d25
begin
	X = convert(Array, data[!,Not(:covid_res)]);
	y = convert(Array, data[!,:covid_res]);
end;

# ╔═╡ 1da3a1d0-6697-11eb-32e7-d7b544ffbb28
md"""Our **target variable** is a column of zeros and ones:"""

# ╔═╡ fcdf6b00-6696-11eb-3b70-a94d2316c8d7
DataFrame(covid_res = y)

# ╔═╡ 41745550-6697-11eb-062a-35fad903d41c
md""" #### Our Input variables
"""

# ╔═╡ 3b2027b0-6697-11eb-3a5e-7fa81a886201
DataFrame(X, names(data[!,Not(:covid_res)]))

# ╔═╡ 8d7322fe-6697-11eb-0280-cb7d8ce27fa2
md"""The below line of code is splitting the data into a training set and test set"""

# ╔═╡ 7d973b10-6697-11eb-36af-b94eb1278ddd
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.5, random_state=42);

# ╔═╡ 10d8d500-6698-11eb-285f-dd02bc6eb853
md"""##### Taking a look at the trainning X""" 

# ╔═╡ 0336b070-6698-11eb-3cbe-a92e5ae467be
DataFrame(X_train, names(data[!,Not(:covid_res)]))

# ╔═╡ 4f1f4190-6699-11eb-285f-5d9a5dd0f7bc
md"""#### Looking at Test X"""

# ╔═╡ 071a0520-6698-11eb-353f-3b96d46773e1
DataFrame(X_test, names(data[!,Not(:covid_res)]))

# ╔═╡ 4b93d0e0-6699-11eb-21b3-9df9ce7bbe44
md"""#### Y Train"""

# ╔═╡ 63ea6ff0-6699-11eb-0384-49a7e5cce81d
DataFrame(covid_res = y_train)

# ╔═╡ a8832ad0-6699-11eb-348f-8ddd45591076
md""" ### Y Test"""

# ╔═╡ b3440160-6699-11eb-30b1-c18f20f4ae6f
DataFrame(covid_res = y_test)

# ╔═╡ f27fd1ce-6697-11eb-0bf7-293f5fe447e2
md""" #### Fitting the Model to Data"""

# ╔═╡ e259c180-6697-11eb-3ce6-8506c5dc4e3f
begin 
	simplelogistic = LogisticRegression(max_iter=300)
	fit!(simplelogistic,X_train,y_train)
end;

# ╔═╡ da6bf630-6699-11eb-0668-33d393e9b2ac
begin 
	y_pred = predict(simplelogistic,X_train)
	
	with_terminal() do
	print(classification_report(y_train,y_pred))
	end
end 

# ╔═╡ a79700a0-669a-11eb-0aa8-4f8ed5b18798
c = cross_val_score(LogisticRegression(), X_train, y_train, cv=5)

# ╔═╡ de055420-669a-11eb-2dfd-a5fdbe772ffb
md"""**Average acurracy of the model with cross validation on training dataset is $(mean(c)) and SD is $(std(c))**"""

# ╔═╡ 97e42f10-669b-11eb-28fc-4bf98f97d749
ctest = cross_val_score(LogisticRegression(), X_test, y_test, cv=5)

# ╔═╡ a74c6da0-669b-11eb-1426-618da4ecb341
md"""**Average acurracy of the model with cross validation on test dataset is $(mean(ctest)) and SD is $(std(ctest))**"""

# ╔═╡ d53e0e30-669b-11eb-0928-637f482b2a51
md"""### Confusion Matrix"""

# ╔═╡ c61d5ff0-669b-11eb-2584-1fb0fd92f02a
begin 
	plot_confusion_matrix(simplelogistic,X_train,y_train)
	gcf()
end

# ╔═╡ Cell order:
# ╠═4dd67540-6696-11eb-313d-49aaec40c97b
# ╠═07836df0-669b-11eb-36e1-c7a130d62f2a
# ╟─84be3e80-6696-11eb-1c2d-695ff4573f91
# ╟─751bd5c0-6699-11eb-1ea5-51bcfdab90a1
# ╟─ba206ea0-6695-11eb-0046-77b8e1fcd083
# ╠═74483970-6696-11eb-0da7-2fa268ef4d25
# ╟─1da3a1d0-6697-11eb-32e7-d7b544ffbb28
# ╟─fcdf6b00-6696-11eb-3b70-a94d2316c8d7
# ╟─41745550-6697-11eb-062a-35fad903d41c
# ╟─3b2027b0-6697-11eb-3a5e-7fa81a886201
# ╟─8d7322fe-6697-11eb-0280-cb7d8ce27fa2
# ╠═7d973b10-6697-11eb-36af-b94eb1278ddd
# ╟─10d8d500-6698-11eb-285f-dd02bc6eb853
# ╟─0336b070-6698-11eb-3cbe-a92e5ae467be
# ╟─4f1f4190-6699-11eb-285f-5d9a5dd0f7bc
# ╟─071a0520-6698-11eb-353f-3b96d46773e1
# ╟─4b93d0e0-6699-11eb-21b3-9df9ce7bbe44
# ╟─63ea6ff0-6699-11eb-0384-49a7e5cce81d
# ╟─a8832ad0-6699-11eb-348f-8ddd45591076
# ╟─b3440160-6699-11eb-30b1-c18f20f4ae6f
# ╟─f27fd1ce-6697-11eb-0bf7-293f5fe447e2
# ╠═e259c180-6697-11eb-3ce6-8506c5dc4e3f
# ╟─da6bf630-6699-11eb-0668-33d393e9b2ac
# ╠═a79700a0-669a-11eb-0aa8-4f8ed5b18798
# ╟─de055420-669a-11eb-2dfd-a5fdbe772ffb
# ╠═97e42f10-669b-11eb-28fc-4bf98f97d749
# ╟─a74c6da0-669b-11eb-1426-618da4ecb341
# ╟─bce85980-669b-11eb-0ce0-051cccead17d
# ╟─d53e0e30-669b-11eb-0928-637f482b2a51
# ╟─c61d5ff0-669b-11eb-2584-1fb0fd92f02a
