using CSV # This is a pacakge we use for loading CSV Files.
using DataFrames
@sk_import model_selection: train_test_split
@sk_import linear_model: LogisticRegression
@sk_import metrics: confusion_matrix
@sk_import metrics: classification_report
@sk_import model_selection: cross_val_score

pathtodata = joinpath("julia-scripts", "model-zoo","covid_cleaned.csv")
data = CSV.read(pathtodata, DataFrame)

X = convert(Array, data[!,Not(:covid_res)])
y = convert(Array, data[!,:covid_res])

X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.33, random_state=42)

simplelogistic = LogisticRegression(penalty=:none)
fit!(simplelogistic,X_train,y_train)

y_pred = predict(simplelogistic,X_test)
print(classification_report(y_train,y_pred))
cross_val_score(LogisticRegression(penalty=:none ), X_train, y_train)
confusion_matrix(y_test,y_pred)