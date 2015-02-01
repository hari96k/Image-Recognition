colorImage = imread('test_images\IMG_2376.jpg');
origImage = colorImage;
arrSize = size(origImage);
arrSize
if max(arrSize) > 1000
    rSize = 1000 / max(arrSize);
%origImage = imresize(origImage, .25);
figure; imshow(colorImage); title('Image');

gray = rgb2gray(origImage);
histImage2 = histeq(gray);
histImage = adapthisteq(gray);

%histImage = hsv(:,:,1);
%histImage2 = histeq(histImage);

figure;imshow(histImage);title('Adaptive HistEQ');
figure;imshow(histImage2);title('Regular HistEQ');

mserRegions = detectMSERFeatures(histImage2);
mserRegionsPixels = vertcat(cell2mat(mserRegions.PixelList));  % extract regions
figure; imshow(histImage); title('MSER Regions');
hold on;
plot(mserRegions, 'showPixelList', true, 'showEllipses', false);
plot(mserRegions);




