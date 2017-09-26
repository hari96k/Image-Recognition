%% Test QR encoding and decoding
%
% Please download and build the core and javase parts of zxing
% from here - http://code.google.com/p/zxing/
%
javaaddpath('core-3.2.1.jar');
javaaddpath('javase-3.2.1.jar');

% encode a new QR code
% test_encode = encode_qr('la la la', [32 32]);
% figure;
% imagesc(test_encode);
% axis image;

% decode
message = decode_qr(imread('test_qr.jpg'));
