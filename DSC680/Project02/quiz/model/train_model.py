import numpy as np
import tensorflow as tf

from sklearn.model_selection import train_test_split
from bidict import bidict

from keras.callbacks import EarlyStopping, ModelCheckpoint
from keras.preprocessing.image import ImageDataGenerator
from keras import layers
from keras.layers import *

class Training:
    def __init__(self):
        self.encoder = bidict({
            'A': 1, 'B': 2, 'C': 3, 'D': 4, 'E': 5, 'F': 6,
            'G': 7, 'H': 8, 'I': 9, 'J': 10, 'K': 11, 'L': 12,
            'M': 13, 'N': 14, 'O': 15, 'P': 16, 'Q': 17, 'R': 18,
            'S': 19, 'T': 20, 'U': 21, 'V': 22, 'W': 23, 'X': 24,
            'Y': 25, 'Z': 26, 'a': 27, 'b': 28, 'c': 29, 'd': 30,
            'e': 31, 'f': 32, 'g': 33, 'h': 34, 'i': 35, 'j': 36,
            'k': 37, 'l': 38, 'm': 39, 'n': 40, 'o': 41, 'p': 42,
            'q': 43, 'r': 44, 's': 45, 't': 46, 'u': 47, 'v': 48,
            'w': 49, 'x': 50, 'y': 51, 'z': 52
        })
        self.labels = np.load('data/labels.npy')
        self.imgs = np.load('data/images.npy')
        self.process_labels()

    def process_labels(self):
        '''
        get the labels and encode them
        '''
        self.labels = np.array([self.encoder[x] for x in self.labels])

    def train_data(self):
        '''
        create training and validation dataset and normalize
        '''
        x_train, x_val, y_train, y_val  = train_test_split(self.imgs, self.labels,
                                                   train_size = 0.80,
                                                   test_size = 0.20,
                                                   random_state = 45)

        x_train = x_train / 255.0
        x_val = x_val / 255.0

        print(f"Training set: {x_train.shape, y_train.shape}")
        print(f"Validation set: {x_val.shape, y_val.shape}")

        return x_train, x_val, y_train, y_val

    def build(self):
        '''
        Process the model
        '''
        # load the data from train_data function
        x_train, x_val, y_train, y_val = self.train_data()

        # set up model
        model = tf.keras.models.Sequential([
            tf.keras.Input(shape=(50, 50, 1)),
            layers.Conv2D(32, (3, 3), activation='relu'),
            layers.MaxPool2D((2,2)),
            layers.Conv2D(64, (3, 3), activation='relu'),
            layers.MaxPool2D((2, 2)),
            layers.Dropout(0.2),
            layers.Conv2D(64, (3, 3), activation='relu'),
            layers.MaxPool2D((2, 2)),
            layers.Dropout(0.2),
            layers.Flatten(),
            layers.Dense(len(self.encoder) + 1, activation = 'softmax')
        ])

        # create checks
        early_stopping = EarlyStopping(monitor = 'val_loss', patience = 5, verbose = 1, mode = 'min')
        mcp_save = ModelCheckpoint('model/letters_model.h5', save_best_only = True, monitor = 'val_loss', verbose = 1, mode = 'auto')
        optimizer = tf.keras.optimizers.Adam()

        # compile the model
        model.compile(loss = 'sparse_categorical_crossentropy',
            optimizer = optimizer,
            metrics = ['accuracy']
        )

        print(model.summary())

        # create data generator
        datagen = ImageDataGenerator(width_shift_range=0.1, height_shift_range=0.1, horizontal_flip=True)

        # prepare iterator
        it_train = datagen.flow(x_train, y_train, batch_size=10)

        steps = int(x_train.shape[0] / 10)

        model.fit(it_train, steps_per_epoch = steps, 
                epochs = 100, validation_data = (x_val, y_val), verbose = 1,
                callbacks = [early_stopping, mcp_save])

        return
