import cv2
import numpy
import matplotlib as plt
import os

def BLOCKSIZE (): return 5

def promptPath():
    impath = 'C:/Users/Ian McDonald/Documents/GitHub/Image-Recognition/iansTests/imageRecTestAndPractice/images/'
    folder = input('Which folder do you wish to enter (currently frames, gray_frames, and pictures):  ')
    impath = impath + folder + '/'
    file = input('picture name?:  ')
    file = file + '.jpg'
    img = cv2.imread(os.path.join(impath, file), 0)
    return img


def blackWhiteGray(img):
    ##image = input
    ##img = cv2.imread(os.path.join(impath, file), 0)


    width, height = img.shape
    print(img.shape)

    ycounter = 0
    while (ycounter < height):
        xcounter = 0
        while (xcounter < width):

            if (img[xcounter, ycounter] > 180 and xcounter + BLOCKSIZE() < width):
                img[xcounter:xcounter + BLOCKSIZE(), ycounter:ycounter + BLOCKSIZE()] = 255
            elif (60<img[xcounter, ycounter] < 180 )and xcounter + BLOCKSIZE() < width:
                img[xcounter:xcounter + BLOCKSIZE(), ycounter:ycounter + BLOCKSIZE()] = 160
            elif (img[xcounter, ycounter] < 60 and xcounter + BLOCKSIZE() < width):
                img[xcounter:xcounter + BLOCKSIZE(), ycounter:ycounter + BLOCKSIZE()] = 0
            elif (img[xcounter, ycounter] > 180 and xcounter + BLOCKSIZE() ):
                img[xcounter: width, ycounter:height] = 255
            elif (60<img[xcounter, ycounter] < 180 )and xcounter + BLOCKSIZE() < width:
                img[xcounter: width, ycounter:height] = 127
            elif (img[xcounter, ycounter] < 60 and xcounter + BLOCKSIZE() < width):
                img[xcounter: width, ycounter:height] = 0

            xcounter += BLOCKSIZE()
        ycounter += BLOCKSIZE()
    return img



##img = blackWhiteGray(img)


##cv2.imshow('pic', img)
##cv2.waitKey(0)
##cv2.destroyAllWindows()

##cap = cv2.videoCapture()

