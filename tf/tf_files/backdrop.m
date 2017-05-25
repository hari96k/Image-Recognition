function [ result ] = backdrop( img )
%img = imread('C:\Users\harsha\Desktop\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw\Square\square (5).jpg');
img = im2uint8(img);
dim = size(img);
new_dim = (randi([5 25],1,1)/100) * [max(dim(1), dim(2)) max(dim(1), dim(2))];
img = padarray(img, ceil(new_dim), 255);

files = dir('backgrounds/*.png');
n = randi([1 length(files)],1,1);
background = imread(char(strcat('backgrounds/background',string(n),'.png')));

imadjustThresh = [(randi([0 30],1,1)/100) (randi([70 100],1,1)/100)];
background = imadjust(background,imadjustThresh,[]);

dim = size(img);
new_dim = [dim(1) dim(2)];
scaled_background = imresize(background, new_dim);

D = double(all(img>randi([200 225],1,1), 3));
% imwrite(img,'temp.png','alpha', D);
% img = imread('temp.png');
img_r = img(:,:,1);
img_b = img(:,:,2);
img_g = img(:,:,3);

back_r = scaled_background(:,:,1);
back_b = scaled_background(:,:,2);
back_g = scaled_background(:,:,3);

img_r(D==1) = back_r(D==1);
img_b(D==1) = back_b(D==1);
img_g(D==1) = back_g(D==1);

result = cat(3, img_r, img_b, img_g);

%imshow(result);

end

