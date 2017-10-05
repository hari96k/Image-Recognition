import tensorflow as tf

#opening pics
contents = tf.read_file('circle.jpg')
image = tf.image.decode_jpeg(contents)

#resizing images
small_image = tf.image.resize_images(image, [100,100])
large_image = tf.image.resize_images(image, [300,300])
long_image = tf.image.resize_images(image, [123,50])
tall_image = tf.image.resize_images(image, [50,119])

#changing colors
rgb_circle = tf.image.decode_jpeg(contents, channels=3)
gray_circle = tf.image.rgb_to_grayscale(image)

#changing orienation
upsidedown_circle = tf.image.flip_up_down(image)
reverse_circle = tf.image.flip_left_right(image)
rotated_circle = tf.image.rot90(image,1)
rotated_circle2 = tf.image.rot90(image,3)

#yes
w = tf.Variable(tf.random_uniform([1], minval=50,maxval=200,dtype=tf.int32))
init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)
a = sess.run(w)
x = a[0]
w = tf.Variable(tf.random_uniform([1], minval=50,maxval=200,dtype=tf.int32))
init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)
a = sess.run(w)
y = a[0]
w = tf.Variable(tf.random_uniform([1], minval=0,maxval=3,dtype=tf.int32))
init = tf.global_variables_initializer()
sess = tf.Session()
sess.run(init)
a = sess.run(w)
z = a[0]
what = tf.image.resize_images(image,[x,y])
what = tf.image.random_brightness(image,3)
what = tf.image.random_contrast(what,0,1000)
what = tf.image.random_hue(what,0.1)
what = tf.image.random_saturation(what,45,1000)
what = tf.image.random_flip_up_down(what)
what = tf.image.random_flip_left_right(what)
what = tf.image.rot90(what,z)
#is this actually doing anything

#finished
final_image = tf.image.encode_jpeg(what,None,None)
