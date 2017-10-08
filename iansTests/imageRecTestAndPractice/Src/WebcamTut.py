import cv2
import numpy
import os
import matplotlib as plt
import datetime

cap = cv2.VideoCapture(1)
path = 'C:/Users/Ian McDonald/Documents/GitHub/Image-Recognition/iansTests/imageRecTestAndPractice/images'
fpath = path + '/frames'
gfpath = path + '/gray_frames'
frameNum = 0
oNow = datetime.datetime.now()
oNowT = oNow.timetuple()
oy, om ,od, oh, omin, osec, owd, oyd , oi = oNowT

while True:
    ret, frame = cap.read()
    cv2.imshow('frame',frame)
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    frameName = 'frame_' + str(frameNum) + '.jpg'
    grayFrameName = 'gray_frame_' + str(frameNum) + '.jpg'

    now = datetime.datetime.now()
    nowT = now.timetuple()
    y, m, d, h, min, sec, wd, yd, i = nowT


    if (omin + 1 <= min):
        cv2.imwrite(os.path.join(fpath, frameName), frame)
        cv2.imwrite(os.path.join(gfpath, grayFrameName), gray)


        frameNum += 1

        oNow = datetime.datetime.now()
        oNowT = oNow.timetuple()
        oy, om, od, oh, omin, osec, owd, oyd, oi = oNowT

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
cap.release
cv2.destroyAllWindows()