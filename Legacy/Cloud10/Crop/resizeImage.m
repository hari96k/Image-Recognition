function [ image ] = resizeImage( image, threshold )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
    imgSize = size(image);
    if max(imgSize) > threshold
        rSize = threshold / (max(imgSize));
        %rSize
        image = imresize(image, rSize);
    end    
end

