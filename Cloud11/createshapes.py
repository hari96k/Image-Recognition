from PIL import Image
from PIL import ImageFilter
from PIL import ImageFont
from PIL import ImageDraw
import random
import math

num = 5
shape = "circle"

for i in range(0,num):
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Star.png')
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Skirt Trapezoid.png')
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Scalene Triangle.png')
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Rectangle.png')
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Iscoeles Triangle.png')
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Equilateral Triangle.png')
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Cross.png')
    foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Circle.png')
    #foreground = Image.open('C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Chisel Trapezoid.png')

    foreground = foreground.convert("RGBA")
    #makes shape transparent and randomizes color
    datas = foreground.getdata()
    r = random.randint(0, 255)
    g = random.randint(0, 255)
    b = random.randint(0, 255)
    newData = []
    for item in datas:
        if item[0] == 255 and item[1] == 255 and item[2] == 255:
            newData.append((255, 255, 255, 0))
        else:
            newData.append((r, g, b))
    foreground.putdata(newData)

    #add alpha
    draw = ImageDraw.Draw(foreground)
    # font = ImageFont.truetype(<font-file>, <font-size>)
    font = ImageFont.truetype("C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\Font\\hi.ttf", 225)
    x, y = foreground.size
    r = random.randint(0, 255)
    g = random.randint(0, 255)
    b = random.randint(0, 255)
    alpha = ("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
    letter = alpha[random.randint(0,25)]
    textX, textY = font.getsize(letter)
    draw.text(((x-textX)/2, (y-textY)/2),letter,(r,g,b),font=font)
    #random background from folder
    bleh = random.randint(1,30)
    pic = "C:/Users/Hari/Documents/UAV/Image-Recognition/Cloud11/backgrounds" + str(bleh) + ".png"
    background = Image.open(pic)
    maxwidth, maxheight = background.size
    resizeRatio = min(maxwidth/x, maxheight/y)*.75
    foreground = foreground.resize((int(x*resizeRatio), int(y*resizeRatio)))
    fg_w, fg_h = foreground.size
    foreground = foreground.rotate(random.randint(0,359), expand=True)
    offset = (int(math.floor((maxwidth - fg_w) / 2)), int(math.floor((maxheight - fg_h) / 2)))
    background.paste(foreground, offset, foreground)
    imagename = "C:\\Users\\sober\\Documents\\Image-Recognition\\Cloud11\\shapes\\example images\\" + shape + str(i+1) +".png"
    background = background.filter(ImageFilter.GaussianBlur(radius=random.randint(0, 3)))
    background.save(imagename)