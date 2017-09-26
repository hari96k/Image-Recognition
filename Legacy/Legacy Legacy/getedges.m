% getedges.m
clear; close all; clc;
I = imread('PracticingCVAbbas/test_images/2014-10-26-2.jpg');
I = imresize(I, 0.25);
bw1 = rgb2gray(I);
bw1 = histeq(bw1);
bw2 = .37*I(:,:,1) + .47*I(:,:,2) + .18*I(:,:,3);
bw2 = histeq(bw2);
hsv = rgb2hsv(I);
h1 = hsv(:,:,1);
h2 = histeq(h1);
figure
imshow(h1)

[tc1,canny1] = edge(bw1,'canny');
[tc2,canny2] = edge(bw2,'canny');
ch1 = edge(h1,'canny');
ch2 = edge(h2,'canny');
[ts1,sobel1] = edge(bw1,'sobel');
[ts2,sobel2] = edge(bw2,'sobel');
sh1 = edge(h1,'sobel');
sh2 = edge(h2,'sobel');
[tl1,lap1] = edge(bw1,'log');
[tl2,lap2] = edge(bw2,'log');
lh1 = edge(h1,'log');
lh2 = edge(h2,'log');

figure,imshow(bw1),title('rdg2gray');
figure,imshow(bw2),title('custom grayscale');

figure,imshow(ch1),title('Canny Edges #1');
figure,imshow(ch2),title('Canny Edges #2');
figure,imshow(sh1),title('Sobel Edges #1');
figure,imshow(sh2),title('Sobel Edges #2');
figure,imshow(lh1),title('Laplacian #1');
figure,imshow(lh2),title('Laplacian #2');
