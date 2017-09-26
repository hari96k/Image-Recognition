%clear; close all; clc

%read in image
img = imread('images\crop18.jpg');
%show image
figure; imshow(img);
%get top two likely colors
[firstColor, secondColor] = getColorByHSV(img);

%print results
fprintf('%s %s\n', firstColor, secondColor);