import tensorflow as tf, sys
import os
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import numpy as np
import warnings
import time
import socket
import threading
from PIL import Image

warnings.filterwarnings("ignore")

directory = ''

# Initializations for tensorflow
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


class ClientThread(threading.Thread):
    def __init__(self, ip, port):
        threading.Thread.__init__(self)
        self.ip = ip
        self.port = port
        print("[+] New thread started for " + ip + ":" + str(port))

    def run(self):
        print("Connection from : " + ip + ":" + str(port))

        # clientsock.send("\nWelcome to the server\n\n")

        data = "dummydata"

        while len(data):
            data = clientsock.recv(100)
            print("Active threads: " + str(threading.active_count()))
            message = str(data, "utf-8")
            message_words = message.split(' ')
            print("Matlab sent : " + message)
            print("Length:" + str(len(message)))
            command = message_words[0]
            print("Command received: " + command)
            if (command == "dir"):
                directory = message_words[1]
                print("New Directory: " + directory)
            elif (command == 'blob'):
                filename = message_words[1]
                # image_path = directory + filename
                img = Image.open(directory + filename)
                cropped_img = img.crop((float(message_words[2]), float(message_words[3]),
                                        float(message_words[2]) + float(message_words[4]) + 20,
                                        float(message_words[3]) + float(message_words[5]) + 20))
                image_array = cropped_img.convert('RGB')
                predictions = sess.run(softmax_tensor, {'DecodeJpeg:0': image_array})

                top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]

                shape = label_lines[top_k[0]]
                confidence = predictions[0][top_k[0]]

                # text_file = open("shape_output.txt", "w")
                # if (confidence > .80):
                result = ("%s with %s confidence" % (shape, confidence)).title()
                print('\n\n' + result + '\n')

            # clientsock.send("You sent me : "+ str(data))
            else:
                pass

        print("Client disconnected...")


host = "localhost"
port = 9999

tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

tcpsock.bind((host, port))

while True:
    tcpsock.listen(4)
    print("\nListening for incoming connections...")
    (clientsock, (ip, port)) = tcpsock.accept()
    newthread = ClientThread(ip, port)
    newthread.start()
