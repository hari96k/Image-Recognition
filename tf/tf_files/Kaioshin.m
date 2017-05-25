%img = imread('C:\Users\harsha\Desktop\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw2\Triangle\triangle (16).jpg');
%img = imread('C:\Users\harsha\Desktop\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw2\Square\square (51).jpg');
%img = imread('C:\Users\harsha\Desktop\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw2\Circle\circle (20).jpg');
img = imread('C:\Users\harsha\Desktop\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw2\Rectangle\rectangle (536).jpg');
%img = imread('C:\Users\harsha\Desktop\UAV\Image-Recognition\tf\tf_files\trainingImagesRaw2\Semi Circle\semi circle (120).jpg');


shapes = 'Rectangle';

numNewImages = 1000;
%alphanumeric = true;

switch shapes
    case 'Triangle'
        files = dir('trainingImagesRaw/Triangle/*.jpg');
    case 'Semi Circle'
        files = dir('trainingImagesRaw/Semi Circle/*.jpg');
    case 'Circle'
        files = dir('trainingImagesRaw/Circle/*.jpg');
    case 'Cross'
        files = dir('trainingImagesRaw/Cross/*.jpg');
    case 'Quarter Circle'
        files = dir('trainingImagesRaw/Quarter Circle/*.jpg');
    case 'Rectangle'
        files = dir('trainingImagesRaw/Rectangle/*.jpg');
    case 'Square'
        files = dir('trainingImagesRaw/Square/*.jpg');        
end

startingIndex = length(files) + 1;

for i=1:numNewImages
    newImg = img;
    transformed = rgb2hsv(newImg);
    transformed(:,:,1) = randi([1 360],1,1)/360;
    %transformed(:,:,2) = randi([0 50],1,1)/100;
    %transformed(:,:,3) = randi([0 100],1,1)/100;
    newImg = hsv2rgb(transformed);
    
    
    %newImg = putAlpha(newImg);
    
    newImg = imresize(newImg, [randi([50 300],1,1) NaN]);
    
    angle = randi([1 359],1,1);
    darkImg = imrotate(newImg, angle);
    
    %Sets border to be white
    tempImg = ~imrotate(true(size(newImg)), angle);
    darkImg(tempImg&~imclearborder(tempImg)) = 255;
    
    newImg = darkImg;
    
    
    newImg = backdrop(newImg);
    newImg = imgaussfilt(newImg, randi([3 10],1,1));
    

    newImg = imgaussfilt(newImg, randi([1 3],1,1));
%     if(alphanumeric)
%         newImg = putAlpha(newImg);
%     end
    
    %imshow(newImg)
    
    %     s   = ceil(size(newImg)/2);
    %     imP = padarray(newImg, s(1:2), 'replicate', 'both');
    %     imR = imrotate(imP, angle);
    %     S   = ceil(size(imR)/2);
    %     newImg = imR(S(1)-s(1):S(1)+s(1)-1, S(2)-s(2):S(2)+s(2)-1, :); %// Final form
    
    switch shapes
        case 'Triangle'
            imwrite(newImg , char(strcat('trainingImagesRaw/Triangle', '/',"triangle (", string(startingIndex), ").jpg")));
        case 'Semi Circle'
            imwrite(newImg , char(strcat('trainingImagesRaw/Semi Circle', '/',"semi (", string(startingIndex), ").jpg")));
        case 'Circle'
            imwrite(newImg , char(strcat('trainingImagesRaw/Circle', '/',"circle (", string(startingIndex), ").jpg")));
        case 'Cross'
            imwrite(newImg , char(strcat('trainingImagesRaw/Cross', '/',"cross (", string(startingIndex), ").jpg")));
        case 'Quarter Circle'
            imwrite(newImg , char(strcat('trainingImagesRaw/Quarter Circle', '/',"quart (", string(startingIndex), ").jpg")));
        case 'Rectangle'
            imwrite(newImg , char(strcat('trainingImagesRaw/Rectangle', '/',"rectangle (", string(startingIndex), ").jpg")));
        case 'Square'
            imwrite(newImg , char(strcat('trainingImagesRaw/Square', '/',"square (", string(startingIndex), ").jpg")));
    end
    
    startingIndex = startingIndex + 1;
end

fprintf(strcat(shapes ,'\tCreated!\n'));


