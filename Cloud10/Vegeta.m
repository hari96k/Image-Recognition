close all; 
%img_test = imread('images/test/bad7.jpg');
img_test = imread('images/image-100.jpg');

img = img_test;
%img2 = imsharpen(img);
filter = .15;
%RGB2 = imadjust(img, [.1 .1 .1; .9 .9 .9]);
se = strel('square',2);
% se2 = strel('square',1);
gray = rgb2gray(img);
%gray = wiener2(gray,[5 5]);
%a_gray = imadjust(gray);
%a_gray = imfilter(a_gray,fspecial('unsharp'));
%[~, threshold] = edge(a_gray, 'sobel');
thisImage = coloredges(img);
thisImage2 = coloredges(img2);
figure;
thisImage = edge(thisImage, 'Canny', filter);
thisImage2 = edge(thisImage2, 'Canny', filter);
 %thisImage = imdilate(thisImage,se);
 %thisImage = imfill(thisImage,'holes');
% thisImage = bwmorph(thisImage, 'remove');
% imshow(thisImage)
% thisImage = imdilate(thisImage,se);
%thisImage = imclose(thisImage, se);
% thisImage = bwmorph(thisImage, 'thin', Inf);
%thisImage = bwperim(thisImage, 4);
% thisImage = imfill(thisImage, 'holes');
% thisImage = ExtractNLargestBlobs(thisImage, 3);
subplot(1,2,1);
imshow(thisImage);
subplot(1,2,2);
imshow(thisImage2);
title('With imsharpen');


% % Credit to the based god Image Analyst
% % Demo to have the user freehand draw an irregular shape over
% % a gray scale image, have it extract only that part to a new image,
% % and to calculate the mean intensity value of the image within that shape.
% %
% % Change the current folder to the folder of this m-file.
% 
% clc;
% clear;
% workspace;
% close all;
% workspace;	% Make sure the workspace panel is showing.
% fontSize = 16;
% % Read in standard MATLAB gray scale demo image.
% grayImage = imread('cameraman.tif');
% subplot(2, 3, 1);
% imshow(grayImage, []);
% title('Original Grayscale Image', 'FontSize', fontSize);
% set(gcf, 'Position', get(0,'Screensize')); % Maximize figure.
% message = sprintf('Left click and hold to begin drawing.\nSimply lift the mouse button to finish');
% uiwait(msgbox(message));
% hFH = imfreehand();
% % Create a binary image ("mask") from the ROI object.
% binaryImage = hFH.createMask();
% % Display the freehand mask.
% subplot(2, 3, 2);
% imshow(binaryImage);
% title('Binary mask of the region', 'FontSize', fontSize);
% % Calculate the area, in pixels, that they drew.
% numberOfPixels1 = sum(binaryImage(:))
% % Another way to calculate it that takes fractional pixels into account.
% numberOfPixels2 = bwarea(binaryImage)
% % Get coordinates of the boundary of the freehand drawn region.
% structBoundaries = bwboundaries(binaryImage);
% xy=structBoundaries{1}; % Get n by 2 array of x,y coordinates.
% x = xy(:, 2); % Columns.
% y = xy(:, 1); % Rows.
% subplot(2, 3, 1); % Plot over original image.
% hold on; % Don't blow away the image.
% plot(x, y, 'LineWidth', 2);
% drawnow; % Force it to draw immediately.
% % Burn line into image by setting it to 255 wherever the mask is true.
% burnedImage = grayImage;
% burnedImage(binaryImage) = 255;
% % Display the image with the mask "burned in."
% subplot(2, 3, 3);
% imshow(burnedImage);
% caption = sprintf('New image with\nmask burned into image');
% title(caption, 'FontSize', fontSize);
% % Mask the image and display it.
% % Will keep only the part of the image that's inside the mask, zero outside mask.
% blackMaskedImage = grayImage;
% blackMaskedImage(~binaryImage) = 0;
% subplot(2, 3, 4);
% imshow(blackMaskedImage);
% title('Masked Outside Region', 'FontSize', fontSize);
% % Calculate the mean
% meanGL = mean(blackMaskedImage(binaryImage));
% % Report results.
% message = sprintf('Mean value within drawn area = %.3f\nNumber of pixels = %d\nArea in pixels = %.2f', ...
% meanGL, numberOfPixels1, numberOfPixels2);
% msgbox(message);
% % Now do the same but blacken inside the region.
% insideMasked = grayImage;
% insideMasked(binaryImage) = 0;
% subplot(2, 3, 5);
% imshow(insideMasked);
% title('Masked Inside Region', 'FontSize', fontSize);
% % Now crop the image.
% topLine = min(x);
% bottomLine = max(x);
% leftColumn = min(y);
% rightColumn = max(y);
% width = bottomLine - topLine + 1;
% height = rightColumn - leftColumn + 1;
% croppedImage = imcrop(blackMaskedImage, [topLine, leftColumn, width, height]);
% % Display cropped image.
% subplot(2, 3, 6);
% imshow(croppedImage);
% title('Cropped Image', 'FontSize', fontSize);