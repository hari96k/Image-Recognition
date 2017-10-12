import cv2
import numpy
import matplotlib as plt
import os

impath = 'C:/Users/Ian McDonald/Documents/GitHub/Image-Recognition/iansTests/imageRecTestAndPractice/images/'
folder = input('Which folder do you wish to enter (currently frames, gray_frames, and pictures):  ')
impath = impath + folder + '/';

file = input('picture name?:  ')
file = file + '.jpg'

image = input
img = cv2.imread(os.path.join(impath, file), 0)

width, height = img.shape
print (img.shape)
print (os.path.join(impath, file))

ycounter = 0
while (ycounter  <  height):
    xcounter = 0
    while (xcounter < width) :

        if (img[xcounter,ycounter] > 180):
                img[xcounter,ycounter] = 255
        elif (img[xcounter,ycounter] <180 and img[xcounter,ycounter] > 60):
            img[xcounter, ycounter] = 127

        else:
            img[xcounter, ycounter] = 0
        xcounter += 1
    ycounter += 1



cv2.imshow('pic', img)
cv2.waitKey(0)
cv2.destroyAllWindows()



##def compareBGR(bgr):
