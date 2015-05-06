function [ mainColor, secondColor ] = getColorByHSV( image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

im_hsv = rgb2hsv(image);
h = im_hsv(:,:,1);
s = im_hsv(:,:,2);
v = im_hsv(:,:,3);

%getMaxIndex returns the index of the highest peak in the 2 dimensional
%matrix. To be used with h,s,v from rgb2hsv(img)

%%% what getMaxIndex(h) does
% hueHist = imhist(h);
% %figure; plot(hueHist);
% [huePeak, hueInd] = findpeaks(hueHist);
% hueArray = [huePeak, hueInd];
% sortHue = sortrows(hueArray, 1);

[maxHue1,maxHue2] = getMaxIndex(h, 360);
%disp(num2str(maxHue1) + ' ' + num2str(maxHue2));
maxSat = getMaxIndex(s, 100);
maxVal = getMaxIndex(v, 100);

mainColor = color(maxHue1, maxSat, maxVal);
secondColor = color(maxHue2, maxSat, maxVal);

end

