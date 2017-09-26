function [ mainColor, secondColor ] = getColorByHSV( image )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%getMaxIndex returns the index of the highest peak in the 2 dimensional
%matrix. To be used with h,s,v from rgb2hsv(img)

im_hsv = rgb2hsv(image);
h = im_hsv(:,:,1);
s = im_hsv(:,:,2);
v = im_hsv(:,:,3);

%%% what getMaxIndex(h) does
% hueHist = imhist(h);
% %figure; plot(hueHist);
% [huePeak, hueInd] = findpeaks(hueHist);
% hueArray = [huePeak, hueInd];
% sortHue = sortrows(hueArray, 1);

%gets top 2 hue values, because there can be 2 different colors
[maxHue1,maxHue2] = getMaxIndex(h, 360);
maxSat = getMaxIndex(s, 100); % get saturation peak
maxVal = getMaxIndex(v, 100); %get value peak

mainColor = color(maxHue1, maxSat, maxVal); %find top color
secondColor = color(maxHue2, maxSat, maxVal); %find second color

end

