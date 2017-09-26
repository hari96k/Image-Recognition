function [ BW, count ] = support( BW )
%support performs adaptive filtering of given blob

area = sum(BW(:));

BW = imfill(BW, 'holes');
newArea = sum(BW(:));

count = 0;

while (newArea - area) < area && count <= 3
    BW = imdilate(BW, strel('square', 2));
    BW = imfill(BW, 'holes');
    newArea = sum(BW(:));
    count = count + 1;
end

