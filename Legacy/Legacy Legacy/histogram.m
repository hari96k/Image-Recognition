img = imread('test_images/zoomed.png');
% img = im2double(img);
% hist(reshape(img,[],3),1:max(img(:))); 
% colormap([1 0 0; 0 1 0; 0 0 1]);

img = rgb2hsv(img);
hue = img(:,:,1);
his = imhist(hue);

[peak, ind] = findpeaks(his);
arr = [peak, ind];
arr2 = sortrows(arr);