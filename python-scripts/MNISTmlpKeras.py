import numpy as np

import matplotlib.pyplot as plt
from keras import models,layers,optimizers,datasets,utils

# New code added for assignment
import pandas as pd

# This was the original code in the book. 
# We will not be using this line of code in our assignment
#(xtrain,ytrain), (xtest,ytest) = datasets.mnist.load_data()

# Start: New code added for assignment
# This parameter specifies how many columns, counting from the left, are output columns.

K = 1

train = pd.read_excel("data/trainingdata.xlsx").to_numpy()
xtrain = train[:, K:]
ytrain = train[:, :K].flatten()

test = pd.read_excel("data/testingdata.xlsx").to_numpy()
xtest = test[:, K:] 
ytest = test[:, :K].flatten()

input_nodes = xtrain.shape[1]

# End: New code added for assignment

# Made minor updates to the original code from the book
#xtrain=xtrain/255
#xtest=xtest/255

# This was the original code in the book. 
# We will not be using this line of code in our assignment
#ytrain=utils.to_categorical(ytrain,10)
#ytest=utils.to_categorical(ytest,10)

inputs=layers.Input(shape=(input_nodes,))
x=layers.Dense(128,activation='relu')(inputs)
#x=layers.Dense(128,activation='relu')(x)
#x=layers.Dense(128,activation='relu')(x)
#x=layers.Dense(128,activation='relu')(x)
#x=layers.Dense(128,activation='relu')(x)

# Made minor updates to the original code from the book
outputs=layers.Dense(K,activation='softmax')(x)

model=models.Model(inputs=inputs,outputs=outputs)

model.compile(loss='binary_crossentropy',
optimizer='Nadam',metrics=['accuracy'])

history = model.fit(xtrain,ytrain,
                    batch_size=128,
                    epochs=10,
                    validation_data=(xtest,ytest))
score=model.evaluate(xtest,ytest)
print('Testloss:',score[0],'Testaccuracy:',score[1])