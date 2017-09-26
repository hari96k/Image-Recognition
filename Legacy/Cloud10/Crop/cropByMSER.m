function [ matrix ] = cropByMSER( image, threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Input:
%       - image - image matrix, actual matrix

colorImage = image;

%colorImage = imadjust(colorImage, [.3, .7],[]);
%resizing done be resizeImage function
bw = rgb2gray(colorImage);  

hsv = rgb2hsv(colorImage);

matrix = [];
for i=1:3
    %histImage = adapthisteq(hsv);
    
    histImage = hsv(:,:,i);
    %histImage2 = histeq(histImage);

    mserRegions = detectMSERFeatures(histImage);
    mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions

    mserMask = false(size(histImage));
    if (size(mserRegionsPixels) > 0)
        ind = sub2ind(size(mserMask), mserRegionsPixels(:,2), mserRegionsPixels(:,1));
    end
    mserMask(ind) = true;

    se1=strel('disk',25);
    se2=strel('disk',7);

    afterMorphologyMask = imclose(mserMask,se1);
    afterMorphologyMask = imopen(mserMask,se2);

    areaThreshold = threshold; % threshold in pixels
    connComp = bwconncomp(afterMorphologyMask);
    stats = regionprops(connComp,'BoundingBox','Area');
    boxes = round(vertcat(stats(vertcat(stats.Area) > areaThreshold).BoundingBox));
    
    matrix = [matrix; boxes];
end
%to print cropped image
%imcrop(origImage, boxes(i,:));


