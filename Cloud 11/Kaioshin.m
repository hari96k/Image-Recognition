img = imread('C:\Users\Hari\Desktop\Cloud 11\trainingImagesRaw\Triangles\triangle14.jpg');
shapes = 'Triangles';
numNewImages = 500;

switch shapes
    case 'Triangles'
        files = dir('trainingImagesRaw/Triangles/*.jpg');
    case 'Semi Circles'
        files = dir('trainingImagesRaw/Semi Circles/*.jpg');
    case 'Circles'
        files = dir('trainingImagesRaw/Circles/*.jpg');
    case 'Quarter Circles'
        files = dir('trainingImagesRaw/Quarter Circles/*.jpg');
end

startingIndex = length(files) + 1;

for i=1:numNewImages
    newImg = imresize(img, [randi([50 300],1,1) NaN]);
    newImg = imgaussfilt(newImg, randi([1 5],1,1));
    
    angle = randi([1 359],1,1);
    
    darkImg = imrotate(newImg, angle);
    
    %Sets border to be white
    tempImg = ~imrotate(true(size(newImg)), angle);
    darkImg(tempImg&~imclearborder(tempImg)) = 255;
    
    newImg = darkImg;
    
    %     s   = ceil(size(newImg)/2);
    %     imP = padarray(newImg, s(1:2), 'replicate', 'both');
    %     imR = imrotate(imP, angle);
    %     S   = ceil(size(imR)/2);
    %     newImg = imR(S(1)-s(1):S(1)+s(1)-1, S(2)-s(2):S(2)+s(2)-1, :); %// Final form
    
    switch shapes
        case 'Triangles'
            imwrite(newImg , char(strcat('trainingImagesRaw/Triangles', '/','triangle', string(startingIndex), '.jpg')));
        case 'Semi Circles'
            imwrite(newImg , char(strcat('trainingImagesRaw/Semi Circles', '/','semi', string(startingIndex), '.jpg')));
        case 'Circles'
            imwrite(newImg , char(strcat('trainingImagesRaw/Circles', '/','circle', string(startingIndex), '.jpg')));
        case 'Quarter Circles'
            imwrite(newImg , char(strcat('trainingImagesRaw/Quarter Circles', '/','quart', string(startingIndex), '.jpg')));
    end
    
    startingIndex = startingIndex + 1;
end

fprintf(strcat(shapes ,'\tCreated!\n'));


