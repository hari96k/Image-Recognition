function [ result ] = putAlpha( img )
%img = imread('C:\Users\harsha\Desktop\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw\Square\square (5).jpg');
img = im2uint8(img);

files = dir('alphanumerics/*.jpg');
n = randi([1 length(files)],1,1);
alphanumeric = imread(char(strcat('alphanumerics/alphanumeric', " (", string(n),').jpg')));

dim = size(alphanumeric);
new_dim = (randi([0 5],1,1)/100) * [max(dim(1), dim(2)) max(dim(1), dim(2))];
alphanumeric = padarray(alphanumeric, ceil(new_dim), 255);


M = double(any(alphanumeric < 100,3));
redChannel = alphanumeric(:, :, 1);
greenChannel = alphanumeric(:, :, 2);
blueChannel = alphanumeric(:, :, 3);
% Make binary pixels red.
redChannel(M == 1) = randi([1 255],1,1);
greenChannel(M == 1) = randi([1 255],1,1);
blueChannel(M == 1) = randi([1 255],1,1);
% Get RGB image again.
alphanumeric = cat(3, redChannel, greenChannel, blueChannel);

% imadjustThresh = [(randi([0 30],1,1)/100) (randi([70 100],1,1)/100)];
% alphanumeric = imadjust(alphanumeric,imadjustThresh,[]);

dim = size(alphanumeric);
new_dim = (randi([30 50],1,1)/100) * [max(dim(1), dim(2)) max(dim(1), dim(2))];
alphanumeric = padarray(alphanumeric, ceil(new_dim), 255);

dim = size(img);
new_dim = [dim(1) dim(1)];
scaled_alphanumeric = imresize(alphanumeric, new_dim);

D = double(any(scaled_alphanumeric < 200, 3));
dim = size(img);
translateVal = floor(abs(dim(1) - dim(2))/2);
appendMat = zeros(max(size(D)), translateVal);

D_translated = horzcat(appendMat, D);
% imwrite(img,'temp.png','alpha', D);
% img = imread('temp.png');
img_r = img(:,:,1);
img_b = img(:,:,2);
img_g = img(:,:,3);

back_r = scaled_alphanumeric(:,:,1);
back_b = scaled_alphanumeric(:,:,2);
back_g = scaled_alphanumeric(:,:,3);

img_r(D_translated==1) = back_r(D==1);
img_b(D_translated==1) = back_b(D==1);
img_g(D_translated==1) = back_g(D==1);

result = cat(3, img_r, img_b, img_g);

%imshow(result);
end