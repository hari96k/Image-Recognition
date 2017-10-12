import cv2
import numpy
import os
import matplotlib as plt


cap = cv2.VideoCapture(1)
path = 'C:/Users/Ian McDonald/Documents/GitHub/Image-Recognition/iansTests/imageRecTestAndPractice/images/pictures'
frameNum = 0

while True:
    ret, frame = cap.read()
    cv2.imshow('frame',frame)
    frameName = 'pic_' + str(frameNum) + '.jpg'

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

    if cv2.waitKey(1) & 0xFF == ord('a'):
        cv2.imwrite(os.path.join(path, frameName), frame)
        frameNum += 1


cap.release
cv2.destroyAllWindows()