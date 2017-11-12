import cv2
import numpy as np
import os
import datetime

#file path and frame name
FRAME_NAME = 'frame_'
file_path = input('file path:    ')

#get start time
oNow = datetime.datetime.now()
oNowT = oNow.timetuple()
oy, om ,od, oh, omin, osec, owd, oyd , oi = oNowT

#declairing the video feed
cap = cv2.VideoCapture(0)

#save the files as black and white every minute, exit on esc
frame_num = 0

#canny x y
x = 50
y = 100

while(True):
    _, frame = cap.read()

    #get current time
    now = datetime.datetime.now()
    nowT = now.timetuple()
    y, m, d, h, min, sec, wd, yd, i = nowT

    if (omin + 1 <= min):
        edge = cv2.Canny(cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY),x,y)
        cv2.imwrite(os.path.join(file_path, FRAME_NAME + str(frame_num) + '.png'), edge)

        frame_num += 1

        oNow = datetime.datetime.now()
        oNowT = oNow.timetuple()
        oy, om, od, oh, omin, osec, owd, oyd, oi = oNowT

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break