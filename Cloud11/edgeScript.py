import cv2
import numpy as np
from matplotlib import pyplot as plt

img = cv2.imread('testImages/test15.jpg', 0)
edges = cv2.Canny(img, 200, 300)

plt.subplot(121),plt.imshow(img,cmap = 'gray')
plt.title('Original Image'), plt.xticks([]), plt.yticks([])
plt.subplot(122),plt.imshow(edges,cmap = 'gray')
plt.title('Edge Image'), plt.xticks([]), plt.yticks([])
plt.show()
