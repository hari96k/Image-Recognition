import cv2
import numpy
import os
import matplotlib as plt
import datetime

cap = cv2.VideoCapture(0)
path = 'C:/Users/Ian McDonald/PycharmProjects/imageRecTestAndPractice/images/frames/'
frameNum = 0
oNow = datetime.datetime.now()
oNowT = oNow.timetuple()
oy, om ,od, oh, omin, osec, owd, oyd , oi = oNowT

while True:
    ret, frame = cap.read()
    cv2.imshow('frame',frame)
    frameName = 'frame_' + str(frameNum) + '.png'

    now = datetime.datetime.now()
    nowT = now.timetuple()
    y, m, d, h, min, sec, wd, yd, i = nowT


    if (omin + 1 <= min):
        cv2.imwrite(os.path.join(path, frameName), frame)


        frameNum += 1

        oNow = datetime.datetime.now()
        oNowT = oNow.timetuple()
        oy, om, od, oh, omin, osec, owd, oyd, oi = oNowT

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break
cap.release
cv2.destroyAllWindows()