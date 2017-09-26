function [ mainColor, secondColor ] = getColorByHSV( image )
%getMaxIndex returns the index of the highest peak in the 2 dimensional
%matrix. To be used with h,s,v from rgb2hsv(img)

im_hsv = rgb2hsv(image);
h = im_hsv(:,:,1);
s = im_hsv(:,:,2);
v = im_hsv(:,:,3);

%gets top 2 hue values, because there can be 2 different colors
[maxHue1, maxHue2] = getMaxIndex(h, 360);
[maxSat1, maxSat2] = getMaxIndex(s, 100); % get saturation peak
[maxVal1, maxVal2] = getMaxIndex(v, 100); %get value peak

mainColor = color(maxHue1, maxSat1, maxVal1); %find top color
secondColor = color(maxHue2, maxSat2, maxVal2); %find second color

end

