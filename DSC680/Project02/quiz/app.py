import numpy as np
import model.train_model as trainpy

from tensorflow.keras.preprocessing import image
from flask import (
    Flask, render_template, request,
    redirect, url_for, session
)
from bidict import bidict
from random import choice
from os.path import exists

from tensorflow import keras

ENCODER = bidict({
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

ENCODER_LOWER = bidict({
    
})

app = Flask(__name__)
app.secret_key = 'my_secret_key'

model = keras.models.load_model('model/letters_model.h5')

def get_new_letter():
    '''
    Gets a random letter

    args:
        None

    returns:
        letter (str)
    '''
    letter = choice(list(ENCODER.keys()))

    return letter

def get_form():
    '''
    Get letter and img from canvas form

    args:
        None

    return:
        letter (str)
        img (array)
    '''
    label = request.form['letter']

    img = request.form['image']
    img = img.split(',')
    img = np.array(img).astype(float).reshape(1, 50, 50)

    return label, img

def predict_letter(img):
    '''
    Predict the letter from the model

    args:
        img (array)

    return:
        letter (str)
    '''
    # predict letter from image
    results = model.predict(img)

    # get the top probability
    pred_letter = np.argmax(results, axis = -1)

    # get the letter that corresponds to the pred_letter
    pred_letter = ENCODER.inverse[pred_letter[0]]
    
    # print results to terminal
    print(f'Results: {pred_letter}')

    return pred_letter

# Route: index
@app.route('/')
def index():
    session.clear()

    return render_template('index.html')

# Route: Training - Get
@app.route('/train', methods = ['GET'])
def train_get():
    session.clear()

    # get message from session, if not there ''
    message = session.get('message', '')

    # Train letters - this will make sure letters are balanced
    labels = np.load('data/labels.npy')

    count = {k: 0 for k in ENCODER.keys()}
    for label in labels:
        count[label] += 1
    count = sorted(count.items(), key = lambda x: x[1])
    letter = count[0][0]

    # render train html
    return render_template('train.html', prompt_value = letter, message = message)

# Route: Training - Post
@app.route('/train', methods = ['POST'])
def train_post():
    label, img = get_form()

    if exists('data/labels.npy'):
        labels = np.load('data/labels.npy')
        labels = np.append(labels, label)
    else:
        labels = np.array([label])

    np.save('data/labels.npy', labels)

    if exists('data/images.npy'):
        imgs = np.load('data/images.npy')
        imgs = np.vstack([imgs, img])
    else:
        imgs = img
    
    np.save('data/images.npy', imgs)

    session['message'] = f'"{ label }" added to the training model'

    return redirect(url_for('train_get'))

# Route: Letters - Get
@app.route('/letters', methods = ['GET'])
def letters_get():
    session.clear()
    
    # get a random letter from ENCODER LETTERS dictionary
    letter = get_new_letter()

    return render_template('letters.html', prompt_value = letter, message = '', prev_letter = '')

# Route: Letters - Post
@app.route('/letters', methods = ['POST'])
def letters_post():
    letter, img = get_form()

    # Get letter from letters form
    prev_letter = letter

    # predict drawn letter
    pred_letter = predict_letter(img)
    
    # get a new random letter from ENCODER LETTERS dictionary if correct
    letter = get_new_letter()
    
    return render_template('letters.html', prompt_value = letter, message = pred_letter, prev_letter = prev_letter)

# Route: Model - Get
@app.route('/train-model', methods=['GET'])
def train_model_get():
    print('Model successfully retrained')

    return render_template('index.html')

# Route: Model - Post
@app.route('/train-model', methods = ['POST'])
def train_model_post():
    if request.form['model_submit']:
        train = trainpy.Training()
        train.build()

    print('Model successfully retrained')
    
    return render_template('index.html')

if __name__ == '__main__':
    app.run(debug = True)