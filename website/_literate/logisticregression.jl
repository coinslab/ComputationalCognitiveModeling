# # Example for Multiclass Regression 
## Loading Packages & Models from packages 
using ScikitLearn
using RDatasets
import ScikitLearn: CrossValidation
using ScikitLearn.CrossValidation: cross_val_score
@sk_import model_selection: train_test_split
@sk_import linear_model: LogisticRegression
@sk_import metrics: confusion_matrix
@sk_import metrics: classification_report
@sk_import metrics: roc_curve
############################################
# ## Loading Dataset 
iris = dataset("datasets", "iris");

# ## Extracting the targets and predictors 
X = convert(Array, iris[!, [:SepalLength, :SepalWidth, :PetalLength, :PetalWidth]]);
X[1:5,:]

#----
y = y = convert(Array, iris[!, :Species]);
y[1:5,:]

# ## Spliting the dataset 
X_train, X_test, y_train, y_test = train_test_split(X, y, random_state=42);

# ## Initializing the model with 200 iterations
logisticmodel = LogisticRegression(fit_intercept=true, max_iter = 200);

# ## Model Fiting 
fit!(logisticmodel, X_train, y_train)
# ## Checking the accuracy 
accuracy = score(logisticmodel, X_train, y_train)

# With Cross Validation
cross_val_score(LogisticRegression(max_iter=130), X_train, y_train; cv=5)

y_pred = predict(logisticmodel, X_train);

# ## Confusion Matrix
cf_matrix =confusion_matrix(y_train, y_pred)

# ## Precision & Recall 
println(classification_report(y_train, y_pred))