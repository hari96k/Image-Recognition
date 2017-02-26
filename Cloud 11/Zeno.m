%% Real-time Car Identification Using Image Data
% Image classification involves determining if an image contains some
% specific object, feature, or activity. The goal of this example is to
% provide a strategy to construct a classifier that can automatically
% detect which car we are looking at using streaming images from a webcam
% feed.
% Copyright (c) 2015, MathWorks, Inc.

clear

load('workspace.mat')
%% Load image data
imset = imageSet('trainingImagesCooked','recursive');

%% Pre-process Training Data: *Feature Extraction*
% Requires: Computer Vision System Toolbox

% Create a bag-of-features from the Car image database
bag = bagOfFeatures(imset,'VocabularySize',500, 'Gridstep', [10 10]);

% Encode the images as new features
imagefeatures = encode(bag,imset);

%% Create a Table using the encoded features
CarData         = array2table(imagefeatures);
CarData.carType = getImageLabels(imset);

%% Use the new features to train a model and assess its performance
classificationLearner

%% Test Trained Model

close all;
se2 = strel('square', 5);


img = imread('testImages/test2.jpg');
%img = imread('trainingImagesRaw/Semi Circles/semi543.jpg');

imgGray = rgb2gray(img);


interEdges = coloredges(img);
interEdges = interEdges / max(interEdges(:));

BWimg = edge(imgGray,'canny', .2);

blobs = regionprops(BWimg, 'BoundingBox');

blobAreas = regionprops(BWimg, 'area');       %Order the blobs by their area
order = [blobAreas.Area];
[~,idx]=sort(order, 'descend');
blobs=blobs(idx);

boundary = blobs(1).BoundingBox;

thisBlob = imcrop(imgGray, boundary + [-5 -5 10 10]);
%thisBlob = imcrop(BWimg, boundary + [-5 -5 10 10]);
% thisBlob = imdilate(thisBlob,se2);
% thisBlob = imfill(thisBlob, 'Holes');
% thisBlob = bwperim(thisBlob, 8);

imwrite(thisBlob, 'temp.jpg');
thisBlob = imread('temp.jpg');


% Step 2: Extract Features
imagefeatures = double(encode(bag,thisBlob));

% Step 3: Predict car using extracted features
[imagepred, probabilities] = predict(trainedModel.ClassificationEnsemble,imagefeatures);

thisShape = imcrop(img, boundary + [-5 -5 10 10]);
imshow(thisShape);
title(strcat('Prediction:',char(imagepred)));

%save workspace.mat