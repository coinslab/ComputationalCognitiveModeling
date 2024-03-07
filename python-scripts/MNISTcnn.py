from math import e
import numpy as np
import matplotlib.pyplot as plt
from keras import models,layers,optimizers,datasets,utils,losses

import matplotlib.image as mpimg
from os import listdir
import pandas as pd


# This was the original code in the book. 
# We will not be using this line of code in our assignment
#(xtrain,ytrain),(xtest,ytest)=datasets.mnist.load_data()

# Start: New code added for assignment
def get_images(folder_name):
    train_images_arr = []
    train_cat_arr = []
    for cat_name in listdir(folder_name):
        for imag_name in listdir(f"{folder_name}/{cat_name}"):
            image = mpimg.imread(f"{folder_name}/{cat_name}/{imag_name}")
            train_images_arr.append(image)
            train_cat_arr.append(cat_name)
    
    return np.stack(train_images_arr), pd.get_dummies(train_cat_arr).astype(int)

folder_name = "ImagesExample/train"
xtrain, ytrain = get_images(folder_name)

folder_name = "ImagesExample/test"
xtest, ytest = get_images(folder_name)

#Getting the shape of each image
input_shape = xtrain.shape[1:]
#Getting the shape of total number of categories that an image can belong to
output_shape = ytrain.shape[1]

# End: New code added for assignment

print(np.shape(xtrain))

# Made minor updates to the original code from the book
plt.matshow(xtrain[0,:,:])

# Made minor updates to the original code from the book
xtrain=xtrain/255
xtest=xtest/255

# Made minor updates to the original code from the book
inputs=layers.Input(shape=(input_shape))
x=layers.Conv2D(32,kernel_size=(3,3),activation='relu')(inputs)
x=layers.Conv2D(64,(3,3),activation='relu')(x)
x=layers.MaxPooling2D(pool_size=(2,2))(x)
x=layers.Dropout(0.25)(x)
x=layers.Flatten()(x)
x=layers.Dense(128,activation='relu')(x)
x=layers.Dropout(0.5)(x)
outputs=layers.Dense(output_shape,activation='softmax')(x)

model=models.Model(inputs=inputs,outputs=outputs)

model.compile(loss=losses.categorical_crossentropy,
optimizer=optimizers.Adadelta(),
metrics=['accuracy'])

model.fit(xtrain,ytrain,
batch_size=128,
epochs=2,
verbose=1,
validation_data=(xtest,ytest))
score=model.evaluate(xtest,ytest,verbose=0)
print('Testloss:',score[0])
print('Testaccuracy:',score[1])
