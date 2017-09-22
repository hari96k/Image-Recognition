import os
import io
import base64
import requests
from PIL import Image

x = 0
for filename in os.listdir('C:\\Users\\Hari\\Documents\\UAV\\Image-Recognition\\Cloud10\\Images_Final'):
    if x == 1:
        exit()
    if filename.endswith(".jpg"):
        img = Image.open(os.path.join('C:\\Users\\Hari\\Documents\\UAV\\Image-Recognition\\Cloud10\\Images_Final', filename))
        byte_array = io.BytesIO()
        img.save(byte_array, format='PNG')
        byte_array = byte_array.getvalue()
        encoded_img = base64.b64encode(byte_array).decode('utf-8')
        d = {"time": 11.11, "data_original": "", "data_warped": encoded_img, "lat": 1, "lon": 1, "height": 1,
             "width": 1, "processed": False, "processed_manual": False}

        url = "http://192.168.0.12:25005/api/images/"
        print(requests.post(url, json=d).text)

        x = x+1
