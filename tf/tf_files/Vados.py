import socket
import threading
import warnings
import pytesseract
import tensorflow as tf
import webcolors
import struct
import scipy
import scipy.misc
import scipy.cluster

from PIL import Image

pytesseract.pytesseract.tesseract_cmd = 'C:/Program Files (x86)/Tesseract-OCR/tesseract'
n_colors = 2

warnings.filterwarnings("ignore")

# Initializations for tensorflow
# Loads label file, strips off carriage return
label_lines = [line.rstrip() for line in tf.gfile.GFile("retrained_labels.txt")]

# Unpersists graph from file
with tf.gfile.FastGFile("retrained_graph.pb", 'rb') as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())
    _ = tf.import_graph_def(graph_def, name='')

sess = tf.Session()

# Feed the image_data as input to the graph and get first prediction
softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')


# class BlobThread(threading.Thread):
#     data = ''
#     directory = ''
#
#     def __init__(self, m, di):
#         threading.Thread.__init__(self)
#         self.data = m
#         self.directory = di
#
#     def run(self):
#         m = str(data, "utf-8")
#         m_split = m.split(' ')
#         print("Matlab sent : " + m)
#         command = m_split[0]
#         print("Command received: " + command)
#         if command == 'blob':
#             filename = m_split[1]
#             # image_path = directory + filename
#             print("Reading from: " + str(self.directory) + filename)
#             img = Image.open(self.directory + filename)
#             cropped_img = img.crop((float(m_split[2]), float(m_split[3]),
#                                     float(m_split[2]) + float(m_split[4]),
#                                     float(m_split[3]) + float(m_split[5])))
#             image_array = cropped_img.convert('RGB')
#             predictions = sess.run(softmax_tensor, {'DecodeJpeg:0': image_array})
#
#             top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]
#
#             shape = label_lines[top_k[0]]
#             confidence = predictions[0][top_k[0]]
#
#             # text_file = open("shape_output.txt", "w")
#             result = ("%s with %s confidence" % (shape, confidence)).title()
#             print('\n\n' + result + '\n' + str(m_split) + '\n')
#             if confidence > .50 and shape != 'nas':
#                 cropped_img.save('C:\\Users\\hari\\Documents\\UAV\\Image-Recognition\\tf\\tf_files\\outputs\\' + str(
#                     shape) + '_' + str(confidence) + '.jpg')
#
#         # clientsock.send("You sent me : "+ str(data))
#         else:
#             pass
#
#         print("Blob processed...")
#         print("Active threads: " + str(threading.active_count()))

def closest_colour(requested_colour):
    min_colours = {}
    for key, name in webcolors.css21_hex_to_names.items():
        r_c, g_c, b_c = webcolors.hex_to_rgb(key)
        rd = (r_c - requested_colour[0]) ** 2
        gd = (g_c - requested_colour[1]) ** 2
        bd = (b_c - requested_colour[2]) ** 2
        min_colours[(rd + gd + bd)] = name
    return min_colours[min(min_colours.keys())]


def get_colour_name(requested_colour):
    try:
        closest_name = webcolors.rgb_to_name(requested_colour)
    except ValueError:
        closest_name = closest_colour(requested_colour)
    return str(closest_name)


def processBlob(data, directory):
    m = str(data, "utf-8")
    m_split = m.split(' ')
    print("Matlab sent : " + m)
    command = m_split[0]
    if command == 'blob':
        filename = m_split[1]
        # image_path = directory + filename
        print("Reading from: " + str(directory) + filename)
        img = Image.open(directory + filename)
        cropped_img = img.crop((float(m_split[2]), float(m_split[3]),
                                float(m_split[2]) + float(m_split[4]),
                                float(m_split[3]) + float(m_split[5])))
        image_array = cropped_img.convert('RGB')
        predictions = sess.run(softmax_tensor, {'DecodeJpeg:0': image_array})

        top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

        shape = label_lines[top_k[0]]
        confidence = predictions[0][top_k[0]]

        # text_file = open("shape_output.txt", "w")
        result = ("%s with %s confidence" % (shape, confidence)).title()
        print('\n\n' + result + '\n' + str(m_split) + '\n')
        # Default is .85
        if confidence > .85 and shape != 'nas':
            # cropped_img.show()

            #### Alphanumeric detection
            char = pytesseract.image_to_string(cropped_img, config='-psm 10')
            if not char.isalnum():
                char = 'NaC'

            #### Color detection

            ar = scipy.misc.fromimage(cropped_img)
            dim = ar.shape
            ar = ar.reshape(scipy.product(dim[:2]), dim[2])
            codes, dist = scipy.cluster.vq.kmeans(ar.astype(float), n_colors)
            primary = get_colour_name(codes[0].astype(int))
            secondary = get_colour_name(codes[1].astype(int))

            cropped_img.save('C:\\Users\\Hari\\Documents\\UAV\\Image-Recognition\\tf\\tf_files\\outputs\\' + str(
                shape) + '_' + char + '_' + primary + '_' + secondary + '_' + str(confidence) + '.jpg')

    # clientsock.send("You sent me : "+ str(data))
    else:
        pass

    print("Blob processed...")


host = "localhost"
port = 9999

tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

tcpsock.bind((host, port))

while True:
    tcpsock.listen()
    print("\nListening for incoming connections...")
    (clientsock, (ip, port)) = tcpsock.accept()  # Blocking
    clientsock.settimeout(20)
    while True:
        try:
            data = clientsock.recv(100)
        except socket.timeout:
            print("\n\nConnection Reset =/")
            print("Active threads: " + str(threading.active_count()))
            break

        message = str(data, "utf-8")
        message_words = message.split(' ')

        if message_words[0] == "dir":
            print("\n****************New File******************")
            print(message)
            d = message_words[1]
            iterations = int(message_words[2])
            for i in range(0, iterations):
                data = clientsock.recv(100)
                # newBlob = BlobThread(data, d)
                # newBlob.start()
                # executor.submit(processBlob, data, d)
                processBlob(data, d)
