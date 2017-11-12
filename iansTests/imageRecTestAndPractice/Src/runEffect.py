import numpy as np
import cv2

import matplotlib as pl

#The video feed, paramiter is the cammera
cap = cv2.VideoCapture(0)

while (True):
    _, frame = cap.read();
    grey = cv2.cvtColor(frame , cv2.COLOR_BGR2GRAY)
    img = cv2.GaussianBlur(grey, (9,9), 0)
    blur = cv2.blur(grey, (5,5))
    width, height = grey.shape
    lap = cv2.Laplacian(img, cv2.CV_64F)
    edges = cv2.Canny(grey, 50 , 100)

    ##cv2.imshow('blur',blur)
    ##cv2.imshow('GaussianBlur',img)
    ##cv2.imshow('Original', frame)
    cv2.imshow('grey' , grey)
    cv2.imshow('edges', edges)
    cv2.imshow('lap', lap)




    k = cv2.waitKey(5) & 0xFF
    if (k == 27):
        break
