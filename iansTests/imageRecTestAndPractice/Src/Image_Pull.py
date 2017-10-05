import cv2
import os
import numpy as np
from matplotlib import pyplot as plt

path = 'C:/Users/Ian McDonald/PycharmProjects/imageRecTestAndPractice/images/'
img = cv2.imread(os.path.join(path,'watch.jpg'),cv2.IMREAD_GRAYSCALE)
cv2.imshow('image', img)

cv2.waitKey(0)
cv2.destroyAllWindows()

plt.imshow(img, cmap = 'gray', interpolation = 'bicubic')
plt.xticks([]), plt.yticks([])  # to hide tick values on X and Y axis
plt.plot([200,300,400],[100,200,300],'c', linewidth=5)
plt.show()
plt.imsave('watchWithLine.png',img)

