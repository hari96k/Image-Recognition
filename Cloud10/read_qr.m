function message = read_qr(image)

javaaddpath('core-3.2.1.jar');
javaaddpath('javase-3.2.1.jar');

message = decode_qr(image);