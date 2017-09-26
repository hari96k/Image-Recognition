files = dir('C:\Users\Hari\Documents\UAV\Image-Recognition\Cloud10\images3\*.jpg');
outputLoc = 'C:\Users\Hari\Documents\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw\NaS\';
outputDir = dir(strcat(outputLoc, '*.jpg'));

count = length(outputDir) + 1;


for file = files'
    img = imread(strcat(file.folder,'/',file.name));
    
    imgGray = rgb2gray(img);

    %BWimgMask = edge(interEdges,'canny', .3);
    BWimgMask = edge(imgGray,'canny', .3);

    se5 = strel('square', 5);

    % thisImageThick is used to determine the boundary of a blob after dilating to fill holes (not displayed though)
    thisImageThick = imdilate(BWimgMask,se5);

    blobs = regionprops(thisImageThick, 'BoundingBox');
      
    z = 1;
    
    while z <= length(blobs)
        boundary = blobs(z).BoundingBox;

        thisBlob = imcrop(img, boundary + [-3 -3 6 6]);
        
        if max(size(thisBlob)) < 600
            imwrite(thisBlob , char(strcat(outputLoc, "NaS (", string(count), ").jpg")));
        end
        
        z = z + 1;
        count = count + 1;
    end
end
