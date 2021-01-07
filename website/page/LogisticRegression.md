@def title = "Getting Data"
@def hascode = true
@def rss = "A short description of the page which would serve as **blurb** in a `RSS` feed; you can use basic markdown here but the whole description string must be a single line (not a multiline string). Like this one for instance. Keep in mind that styling is minimal in RSS so for instance don't expect maths or fancy styling to work; images should be ok though: ![](https://upload.wikimedia.org/wikipedia/en/b/b0/Rick_and_Morty_characters.jpg)"
@def rss_title = "More goodies"
@def rss_pubdate = Date(2019, 5, 1)

@def tags = ["syntax", "code", "image"]

# Multiclass Logistic Regression 



## Loading Packages & Modules from packages 

```julia
using ScikitLearn
using RDatasets
import ScikitLearn: CrossValidation
@sk_import linear_model: LogisticRegression
@sk_import metrics: confusion_matrix
@sk_import metrics: classification_report
@sk_import metrics: roc_curve
```



## Loading the dataset 

```julia
iris = dataset("datasets", "iris")
```

```julia
150×5 DataFrame
 Row │ SepalLength  SepalWidth  PetalLength  PetalWidth  Species   
     │ Float64      Float64     Float64      Float64     Cat…      
─────┼─────────────────────────────────────────────────────────────
   1 │         5.1         3.5          1.4         0.2  setosa
   2 │         4.9         3.0          1.4         0.2  setosa
   3 │         4.7         3.2          1.3         0.2  setosa
   4 │         4.6         3.1          1.5         0.2  setosa
   5 │         5.0         3.6          1.4         0.2  setosa
  ⋮  │      ⋮           ⋮            ⋮           ⋮           ⋮
 146 │         6.7         3.0          5.2         2.3  virginica
 147 │         6.3         2.5          5.0         1.9  virginica
 148 │         6.5         3.0          5.2         2.0  virginica
 149 │         6.2         3.4          5.4         2.3  virginica
 150 │         5.9         3.0          5.1         1.8  virginica
                                                   140 rows omitted
```



```julia
X = convert(Array, iris[!, [:SepalLength, :SepalWidth, :PetalLength, :PetalWidth]]);
X[1:5,:]
```

```julia
5×4 Array{Float64,2}:
 5.1  3.5  1.4  0.2
 4.9  3.0  1.4  0.2
 4.7  3.2  1.3  0.2
 4.6  3.1  1.5  0.2
 5.0  3.6  1.4  0.2
```



```julia
y = y = convert(Array, iris[!, :Species]);
y[1:5,:]
```

```julia
5×1 Array{String,2}:
 "setosa"
 "setosa"
 "setosa"
 "setosa"
 "setosa"
```



## Splitting the dataset 

```julia
logisticmodel = LogisticRegression(fit_intercept=true, max_iter = 200);
```



## Model Fitting 



```julia
fit!(logisticmodel, X_train, y_train)
```



### Checking the Accuracy 

```julia
accuracy = score(logisticmodel, X_train, y_train)
```

```julia
0.9642857142857143
```

### With Cross-Validation

```julia
cross_val_score(LogisticRegression(max_iter=130), X_train, y_train; cv=5)
```

```julia
5-element Array{Float64,1}:
 1.0
 1.0
 0.8695652173913043
 1.0
 0.9523809523809523
```

```julia
y_pred = predict(logisticmodel, X_train);
```

### Confusion Matrix

```julia
cf_matrix =confusion_matrix(y_train, y_pred)
```

```julia
3×3 Array{Int64,2}:
 35   0   0
  0  36   3
  0   1  3
```

### Precision & Recall

```julia
println(classification_report(y_train, y_pred))
```

```julia

              precision    recall  f1-score   support

      setosa       1.00      1.00      1.00        35
  versicolor       0.97      0.92      0.95        39
   virginica       0.93      0.97      0.95        38

    accuracy                           0.96       112
   macro avg       0.97      0.97      0.97       112
weighted avg       0.97      0.96      0.96       112
```

