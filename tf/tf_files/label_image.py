import tensorflow as tf, sys
import os
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import warnings
import time

warnings.filterwarnings("ignore")

# from PIL.Image import core as image

count = 0

try:
    directory = sys.argv[1]
except IndexError:
    print("Invalid arguments. Please provide an image directory")
    exit(1)

# Loads label file, strips off carriage return
label_lines = [line.rstrip() for line in tf.gfile.GFile("/tf_files/retrained_labels.txt")]

# Unpersists graph from file
with tf.gfile.FastGFile("/tf_files/retrained_graph.pb", 'rb') as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())
    _ = tf.import_graph_def(graph_def, name='')


sess = tf.Session()

# Feed the image_data as input to the graph and get first prediction
softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')

t0 = time.clock()

for filename in os.listdir(directory):

    if filename.endswith(".jpg"):
        count += 1

        image_path = (directory + filename)

        # Read in the image_data
        image_data = tf.gfile.FastGFile(image_path, 'rb').read()

        #with tf.Session() as sess:

        predictions = sess.run(softmax_tensor, {'DecodeJpeg/contents:0': image_data})

        # Sort to show labels of first prediction in order of confidence
        top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

        shape = label_lines[top_k[0]]
        confidence = predictions[0][top_k[0]]

            # for node_id in top_k:
            #     human_string = label_lines[node_id]
            #     score = predictions[0][node_id]
            #     print('%s (score = %.5f)' % (human_string, score))
            #     if node_id == top_k[0]:
            #         shape = human_string
            #         confidence = score




        #text_file = open("shape_output.txt", "w")
        if(confidence > .80):
            result = ("%s with %s confidence" % (shape, confidence)).title()
            print ('\n\n' + result)
            # image = mpimg.imread(image_path)
            # plt.imshow(image)
            # plt.title(result)
            # plt.show()
#text_file.write(result)

t1 = time.clock()

totalTime = t1 - t0
print (totalTime)
print("Total Images Processed: " + str(count))
print("Average Time: " + str(totalTime/count))
# k = cv2.waitKey(0) & 0xFF
# if k == 27:
#    cv2.destroyAllWindows()
