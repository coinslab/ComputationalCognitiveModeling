using CSV, DataFrames, ScikitLearn, PyPlot
pathtodata = joinpath("julia-scripts", "model-zoo", "covid_cleaned.csv")
data = DataFrame(CSV.File(pathtodata))

X = convert(Array, data[!, Not(:covid_res)])
y = convert(Array, data[!, :covid_res])

@sk_import model_selection:train_test_split
X_train, X_test, y_train, y_test = train_test_split(X, y; test_size=0.5, random_state=42)

@sk_import tree:DecisionTreeClassifier
tree = DecisionTreeClassifier()
fit!(tree, X_train, y_train)

y_predict = predict(tree, X_train)

@sk_import metrics:classification_report
print(classification_report(y_train, y_predict))

@sk_import metrics:plot_confusion_matrix
plot_confusion_matrix(tree, X_train, y_train)
PyPlot.gcf()
