import tensorflow as tf, sys
import Image
import numpy as np
import cv2

def get_targets(image_path, boundary):
    boundary = boundary.tolist()
    boundary = map(int, boundary)

    # from PIL.Image import core as image
    #image_path = "testImages/test14.jpg"

    # Read in the image_data
    image_data = tf.gfile.FastGFile(image_path, 'rb').read()
    #cropped_img = tf.image.pad_to_bounding_box(image_data, boundary[1], boundary[0], boundary[1] + boundary[3] + 20, boundary[0] + boundary[2] + 20)
    img = Image.open(image_path)
    cropped_img = img.crop((boundary[0], boundary[1], boundary[0] + boundary[2] + 20, boundary[1] + boundary[3] + 20))
    image_array = cropped_img.convert('RGB')
    #cropped_img.show()
    #image_data.show()

    # Loads label file, strips off carriage return
    label_lines = [line.rstrip() for line
                   in tf.gfile.GFile("/tf_files/retrained_labels.txt")]

    # Unpersists graph from file
    with tf.gfile.FastGFile("/tf_files/retrained_graph.pb", 'rb') as f:
        graph_def = tf.GraphDef()
        graph_def.ParseFromString(f.read())
        _ = tf.import_graph_def(graph_def, name='')

    with tf.Session() as sess:
        # Feed the image_data as input to the graph and get first prediction
        softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')

        predictions = sess.run(softmax_tensor, {'DecodeJpeg:0': image_array})

        # Sort to show labels of first prediction in order of confidence
        top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

        for node_id in top_k:
            human_string = label_lines[node_id]
            score = predictions[0][node_id]
            print('%s (score = %.5f)' % (human_string, score))
            if node_id == top_k[0]:
                shape = human_string

    return shape.title()

    #text_file = open("shape_output.txt", "w")
    #result = ("%s with %s confidence" % (shape, confidence)).title()
    #text_file.write(result)


    #image = cv2.imread(image_path, 1)
    #cv2.imshow(shape, image)
    #k = cv2.waitKey(0) & 0xFF
    #if k == 27:
    #    cv2.destroyAllWindows()
