img = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Triangle\triangle (46).jpg');

newImg = img;
transformed = rgb2hsv(newImg);
transformed(:,:,1) = randi([1 360],1,1)/360;
%transformed(:,:,2) = randi([0 50],1,1)/100;
%transformed(:,:,3) = randi([0 100],1,1)/100;
newImg = hsv2rgb(transformed);


newImg = putAlpha(newImg, false, 'A');

newImg = imresize(newImg, [randi([50 150],1,1) NaN]);

newImg = backdrop(newImg);
newImg = imgaussfilt(newImg, randi([3 5],1,1));

imgGray = rgb2gray(newImg);

initThresh = .2;

%BWimgMask = edge(interEdges,'canny', .3);
edgeImg = edge(imgGray,'canny', initThresh);

noiseLVL = 1;

edgeImg = bwareaopen(edgeImg, 10);

blobs = regionprops(edgeImg, 'BoundingBox');

while length(blobs) > 3
    edgeImg = bwareaopen(edgeImg, 50*noiseLVL);
    noiseLVL = noiseLVL + 1;
    blobs = regionprops(edgeImg, 'BoundingBox');
end

thickImg = imdilate(edgeImg, strel('square', 5));

thickImg = ExtractNLargestBlobs(thickImg, 1);
filledImg = imfill(thickImg, 'holes');
complementImg = imcomplement(filledImg);

imshow(filledImg);
