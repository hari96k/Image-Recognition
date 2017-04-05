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


class ThreadedServer(object):
    directory = ''

    def __init__(self, host, port):
        print("New ThreadServer Created!")
        self.host = host
        self.port = port
        self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind((self.host, self.port))

    def listen(self):
        self.sock.listen(5)
        while True:
            client, address = self.sock.accept()
            client.settimeout(60)
            threading.Thread(target=self.listenToClient, args=(client, address)).start()
            print("Active threads: " + str(threading.active_count()))

    def listenToClient(self, client, address):
        print("Client: " + str(client) + "Address: " + str(address))
        size = 200
        try:
            data = client.recv(size)
            if data:
                message = str(data, "utf-8")
                message_words = message.split(' ')
                print("Matlab sent : " + message)
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
                    if (confidence > .80):
                        result = ("%s with %s confidence" % (shape, confidence)).title()
                        print('\n\n' + result + '\n')

            else:
                print('Client disconnected!')
        except:
            client.close()
            return False


host = "localhost"
port = 9999

tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

tcpsock.bind((host, port))

ThreadedServer(host, port).listen()


# threads = []
#
#
# while True:
#     tcpsock.listen(4)
#     print ("\nListening for incoming connections...")
#     (clientsock, (ip, port)) = tcpsock.accept()
#     newthread = ThreadedServer(ip, port)
#     newthread.start()
#     threads.append(newthread)

# for t in threads:
#     t.join()
