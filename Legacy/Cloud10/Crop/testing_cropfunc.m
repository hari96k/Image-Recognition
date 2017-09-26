image = imread('test_images\IMG_2376.jpg');
% image
%figure;imshow(image);
H = fspecial('gaussian');
img = imfilter(image, H, 'replicate');
figure; imshow(img); title('Gaussian Blur'); 
%img = imadjust(img,[0.5 0.6],[]);
minSizeCroppedAreas = 1000;

img = resizeImage(img, minSizeCroppedAreas);
boxes = cropByMSER(img, minSizeCroppedAreas);
% boxes

for i=1:size(boxes)
    %create cropped image
    crop = imcrop(img, boxes(i,:));
%     crop
    %show cropped image
    %crop = rgb2gray(crop);
    figure; imshow(crop);
    if i == 17
        imwrite(crop, strcat('crop',num2str(i+1),'.jpg'));
    end
    %if i == 7 || i == 8 || i == 3
    %imwrite(crop, strcat('crop',num2str(i+1),'.jpg'));
    %end
end