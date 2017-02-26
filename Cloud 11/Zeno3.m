websave('\example.mat','http://www.vlfeat.org/matconvnet/models/beta16/imagenet-caffe-alex.mat');

% Load MatConvNet network into a SeriesNetwork
convnet = helperImportMatConvNet(cnnFullMatFile);


% View the CNN architecture
convnet.Layers