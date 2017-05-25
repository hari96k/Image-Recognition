import socket
import threading
import warnings
from concurrent.futures import ThreadPoolExecutor

import tensorflow as tf
from PIL import Image

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
#                 cropped_img.save('C:\\Users\\harsha\\Desktop\\UAV\\Image-Recognition\\tf\\tf_files\\outputs\\' + str(
#                     shape) + '_' + str(confidence) + '.jpg')
#
#         # clientsock.send("You sent me : "+ str(data))
#         else:
#             pass
#
#         print("Blob processed...")
#         print("Active threads: " + str(threading.active_count()))


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
        if confidence > .50 and shape != 'nas':
            cropped_img.save('C:\\Users\\harsha\\Desktop\\UAV\\Image-Recognition\\tf\\tf_files\\outputs\\' + str(
                shape) + '_' + str(confidence) + '.jpg')

    # clientsock.send("You sent me : "+ str(data))
    else:
        pass

    print("Blob processed...")
    print("Active threads: " + str(threading.active_count()))

host = "localhost"
port = 9999

tcpsock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
tcpsock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)

tcpsock.bind((host, port))

executor = ThreadPoolExecutor(max_workers=9)

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

                executor.submit(processBlob, data, d)
