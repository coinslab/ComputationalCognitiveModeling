using ScikitLearn
using CSV # This is a pacakge we use for loading CSV Files.
using DataFrames
using DataFramesMeta
using MLDataPattern
using ProgressMeter
using PyPlot
@sk_import model_selection:train_test_split
@sk_import linear_model:LogisticRegression
@sk_import neural_network:MLPClassifier
@sk_import metrics:accuracy_score
@sk_import metrics:f1_score
@sk_import metrics:classification_report
@sk_import metrics:recall_score
@sk_import metrics:roc_auc_score
@sk_import metrics:confusion_matrix
@sk_import model_selection:cross_val_score
pathtodata = joinpath("julia-scripts", "model-zoo", "covid.csv")
rawdata = CSV.read("covid.csv", DataFrame)

#=================================================================#
#===================== Data Pre-processing =======================#
#=================================================================#

# getting rid of columns we are not interested in 
rawdata = rawdata[
    !, Not([:id, :entry_date, :date_symptoms, :date_died, :patient_type, :icu, :sex])
]

# From the data description document we know that 97, 98 or 99 stands for missing data 
# so we are getting rid of rows with those values 
datawithoutmissing = @linq where(
    :intubed .!= 97,
    :intubed .!= 99,
    :pneumonia .!= 99,
    :pregnancy .!= 97,
    :pregnancy .!= 98,
    :diabetes .!= 98,
    :copd .!= 98,
    :asthma .!= 98,
    :inmsupr .!= 98,
    :hypertension .!= 98,
    :other_disease .!= 98,
    :cardiovascular .!= 98,
    :obesity .!= 98,
    :tobacco .!= 98,
    :renal_chronic .!= 98,
    :contact_other_covid .!= 99,
    :covid_res .!= 3,
)(rawdata)

for col in names(datawithoutmissing)
    replace!(datawithoutmissing[!, col], 2 => 0)
end

pathtocleandata = joinpath("julia-scripts", "model-zoo", "covid_cleaned.csv")
# Saving the cleaned data 
# CSV.write(pathtocleandata, datawithoutmissing)

X = convert(Array, datawithoutmissing[!, Not(:covid_res)])
y = convert(Array, datawithoutmissing[!, :covid_res])

X_train, X_test, y_train, y_test = train_test_split(X, y; test_size=0.33, random_state=42)

#=================================================================#
#========================= Model Defenition ======================#
#=================================================================#

# A Simple Logisitic Regression Model with no penalty
simplelogistic = LogisticRegression(; fit_intercept=true, penalty=:none, max_iter=200)
# A Logisitic Regression Model with L2 penalty
logisticL2 = LogisticRegression(; fit_intercept=true, penalty=:l2, max_iter=200)

# A Simple 1 layer Neural Network with 10 nodes 
mlp_1layer10nodes = MLPClassifier(; hidden_layer_sizes=10)

# A Simple 1 layer Neural Network with 30 nodes 
mlp_1layer30nodes = MLPClassifier(; hidden_layer_sizes=30)

# A 2 layer Neural Network with 30 nodes each 
mlp_2layer30nodes = MLPClassifier(; hidden_layer_sizes=(30, 30))

# A 2 layer Neural Network with 100 nodes each 
mlp_2layer100nodes = MLPClassifier(; hidden_layer_sizes=(100, 100))

# A 6 layer deep neural network with varying nodes 
mlp_6layer = MLPClassifier(; hidden_layer_sizes=(30, 50, 60, 10, 10, 10))

models = [
    simplelogistic,
    logisticL2,
    mlp_1layer10nodes,
    mlp_1layer30nodes,
    mlp_2layer30nodes,
    mlp_2layer100nodes,
    mlp_6layer,
]

function get_prediction(input)
    return predict(simplelogistic, [input])
end

function get_metrics(model, X_train, y_train)
    y_pred = predict(model, X_train)
    acc = accuracy_score(y_train, y_pred)
    f1 = f1_score(y_train, y_pred)
    precision = precision_score(y_train, y_pred)
    recall = recall_score(y_train, y_pred)
    roc = roc_auc_score(y_train, y_pred)
    confusion = confusion_matrix(y_train, y_pred)
    return precision, recall, confusion
end

#=================================================================#
#========================= Model Training ========================#
#=================================================================#
@showprogress for model in models
    fit!(model, X_train, y_train)
end

get_metrics(simplelogistic, X_test, y_test)
y_pred = predict(simplelogistic, X_train)
print(classification_report(y_train, y_pred))

cross_validated = cross_val_score(
    LogisticRegression(; penalty=:none, max_iter=200), X_train, y_train
)
