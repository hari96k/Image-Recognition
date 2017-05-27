%get all images from dir images
files = dir('images/*.jpg')';
count = 1;
for file = files,	
	
    %read in images
	img = imread(['images/' file.name]);
    %displays image
	figure; imshow(img);
    
    %gets top two most likely colors
    [firstColor, secondColor] = getColorByHSV(img);
    
    %print out results
    fprintf('\nFigure %d\n', count);
    count = count + 1;
    fprintf('%s %s\n', firstColor, secondColor);
	
	
end