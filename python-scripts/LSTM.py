from keras.preprocessing import sequence
from keras import models,layers,optimizers,datasets,utils,losses

# Start: New code added for assignment
import tensorflow as tf
import string
import re
# End: New code added for assignment

vocabulary_size=20000
maxlen=8
batch_size=32

# This was the original code in the book. 
# We will not be using this line of code in our assignment
#(xtrain,ytrain),(xtest,ytest)=datasets.imdb.load_data(numwords=vocabulary_size)


# Start: New code added for assignment
# Below code is taken from parts of Keras-NLP tutorial - https://keras.io/examples/nlp/text_classification_from_scratch/
max_features=16
sequence_length = 500


def custom_standardization(input_data):
    lowercase = tf.strings.lower(input_data)
    stripped_html = tf.strings.regex_replace(lowercase, "<br />", " ")
    return tf.strings.regex_replace(
        stripped_html, f"[{re.escape(string.punctuation)}]", ""
    )

vectorize_layer = layers.TextVectorization(
    standardize=custom_standardization,
    max_tokens=max_features,
    output_mode="int",
    output_sequence_length=sequence_length,
)


def vectorize_text(text, label):
    print(text, label)
    text = tf.expand_dims(text, -1)
    return vectorize_layer(text), label

train_dataset = utils.text_dataset_from_directory("DocumentExample/train")

text_ds = train_dataset.map(lambda x, y: x)
# Let's call `adapt`:
vectorize_layer.adapt(text_ds)

train_ds = train_dataset.map(vectorize_text)

test_dataset = utils.text_dataset_from_directory("DocumentExample/test")

test_ds = train_dataset.map(vectorize_text)

# End: New code added for assignment


# This was the original code in the book. 
# We will not be using this line of code in our assignment
#xtrain=sequence.pad_sequences(xtrain,maxlen)
#xtest=sequence.pad_sequences(xtest,maxlen)

inputs=layers.Input(shape=(None,))
e=layers.Embedding(max_features,128)(inputs)
h=layers.LSTM(128,dropout=0.8,recurrent_dropout=0.8)(e)
h=layers.Dropout(0.7)(h)
outputs=layers.Dense(1,activation='sigmoid')(h)
model=models.Model(inputs,outputs)


model.compile(loss='binary_crossentropy',
optimizer='adam',
metrics=['accuracy'])

model.fit(train_ds,batch_size=batch_size,epochs=4,
        validation_data=test_ds)

score,acc=model.evaluate(test_ds,batch_size=batch_size)
print('Testaccuracy:',acc)
