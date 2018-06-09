import base64
import io
import warnings

import cv2
import numpy
import scipy
import scipy.cluster
import scipy.misc
import tensorflow as tf
import webcolors
from PIL import Image
import matplotlib.pyplot as plt


color_img = Image.open('C:/Users/Hari/Documents/UAV/Image-Recognition/Cloud11/testImages/flighttest2.jpg')
plt.imshow(color_img)
plt.title('Original')
plt.show(block=False)
#img = cv2.imread('/home/hari/Dropbox/Testing_Images/test0.jpg', 0)


n_colors = 2

num_posted = 0

# List of all colors:
colors_set = {'#ffffff': 'white', '#000000': 'black', '#008000': 'green', '#808080': 'gray', '#0000ff': 'blue',
              '#ffff00': 'yellow', '#ffa500': 'orange', '#ff0000': 'red', '#800080': 'purple', '#A52A2A': 'brown'}

warnings.filterwarnings("ignore")

# Initializations for tensorflow
# Loads label file, strips off carriage return

# For shape classification
# label_lines = [line.rstrip() for line in tf.gfile.GFile("Cloud11/retrained_labels.txt")]

label_lines = [line.rstrip() for line in tf.gfile.GFile("Cloud11/retrained_labels.txt")]

# Unpersists graph from file

# For shape classification
#with tf.gfile.FastGFile("Cloud11/retrained_graph.pb", 'rb') as f:
with tf.gfile.FastGFile("Cloud11/retrained_graph.pb", 'rb') as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())
    _ = tf.import_graph_def(graph_def, name='')

sess = tf.Session()

# Feed the image_data as input to the graph and get first prediction
softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')

# image_array = color_img.convert('RGB')
# predictions = sess.run(softmax_tensor, {'DecodeJpeg:0': image_array})
#
# top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]
#
# alpha = label_lines[top_k[0]]
#
# for i in range(0, len(label_lines)):
# 	print (label_lines[top_k[i]])
#
# exit()

def get_colour_name(requested_colour):
    min_colours = {}
    for key, name in colors_set.items():
        r_c, g_c, b_c = webcolors.hex_to_rgb(key)
        rd = (r_c - requested_colour[0]) ** 2
        gd = (g_c - requested_colour[1]) ** 2
        bd = (b_c - requested_colour[2]) ** 2
        min_colours[(rd + gd + bd)] = name
    return min_colours[min(min_colours.keys())]

padding = 20

def process_blob(x, y, w, h):

    if(w < 20 or h < 20):
        return

    # image_path = directory + filename
    cropped_img = color_img.crop((x - int(padding/2), y - int(padding/2), x + w + int(padding/2), y + h + int(padding/2)))
    image_array = cropped_img.convert('RGB')
    predictions = sess.run(softmax_tensor, {'DecodeJpeg:0': image_array})

    top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

    shape = label_lines[top_k[0]]
    confidence = predictions[0][top_k[0]]

    if shape != 'nas':
        plt.figure()
        plt.imshow(cropped_img)
        plt.title(shape + ' ' + str(confidence))
        plt.show(block=False)

    # Default is .85
    if confidence > .85 and shape != 'nas':
        w, h = cropped_img.size
        # cropped_img = cropped_img.crop((10, 10, w - 20, h - 20))
        w, h = cropped_img.size
        if w > 20 and h > 20:
            inside_img = cropped_img.crop((5, 5, w - 10, h - 10))
        else:
            inside_img = cropped_img
        # cropped_img.show()

        # Alphanumeric detection
        # char = pytesseract.image_to_string(cropped_img, config='-psm 10')
        # if not char.isalnum():
        #     char = 'NaC'

        # Color detection
        ar = scipy.misc.fromimage(inside_img)
        dim = ar.shape
        ar = ar.reshape(scipy.product(dim[:2]), dim[2])
        codes, dist = scipy.cluster.vq.kmeans(ar.astype(float), n_colors)
        primary = get_colour_name(codes[0].astype(int))
        secondary = get_colour_name(codes[1].astype(int))

        # cropped_img.save('C:\\Users\\Hari\\Documents\\UAV\\Image-Recognition\\tf\\tf_files\\outputs\\' + str(
        #     shape) + '_' + char + '_' + primary + '_' + secondary + '_' + str(confidence) + '.jpg')
        # inside_img.save(
        #     'C:\\Users\\Hari\\Documents\\UAV\\Image-Recognition\\tf\\tf_files\\outputs\\' + '_' + primary + '_' + secondary + '_' + str(
        #         confidence) + '.jpg')

        # byte_array = io.BytesIO()
        # cropped_img.save(byte_array, format='PNG')


# cv2.imshow('Original', img)

cv_img = cv2.cvtColor(numpy.array(color_img), cv2.COLOR_RGB2BGR)
edges = cv2.Canny(cv_img, 200, 500)


plt.imshow(edges)
plt.title('Edges')
plt.show(block=True)

#
# exit()

ret, thresh = cv2.threshold(edges, 127, 255, 0)
image, contours, hierarchy = cv2.findContours(thresh, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)

for cnt in contours:
    # mask = np.zeros(im2.shape,np.uint8)
    # cv2.drawContours(mask,[cnt],0,255,-1)
    x, y, w, h = cv2.boundingRect(numpy.asarray(cnt))
    process_blob(x, y, w, h)
# cv2.rectangle(edges,(x,y),(x+w,y+h),(255,255,255),2)
# cv2.imshow('Features', edges)
# cv2.waitKey(0)
# cv2.destroyAllWindows()

plt.waitforbuttonpress()
