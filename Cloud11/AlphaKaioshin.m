triangle = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Triangle\triangle (16).jpg');
square = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Square\square (51).jpg');
circle = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Circle\circle (20).jpg');
rectangle = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Rectangle\rectangle (447).jpg');
semi = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Semi Circle\semi circle (59).jpg');
star = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Star\star (349).jpg');
cross = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Cross\cross (112).jpg');
quarter = imread('C:\Users\Hari\Desktop\trainingImagesRaw2\Quarter Circle\quarter circle (39).jpg');

shapes = (1:1:8);

alphadirs = dir('C:\Users\Hari\Desktop\trainingAlphas');
numNewAlphas = 1000;

for j=3:28
    curdir = strcat(alphadirs(j).folder, '\', alphadirs(j).name);
    files = dir(strcat(curdir, '/*.jpg'));
    startingIndex = length(files) + 1;
    for i=1:numNewAlphas
        switch randi([1 8],1,1)
            case 1
                img = triangle;
            case 2
                img = square;
            case 3
                img = circle;
            case 4
                img = rectangle;
            case 5
                img = semi;
            case 6
                img = star;
            case 7
                img = cross;
            case 8
                img = quarter;             
        end
        
        newImg = img;
        transformed = rgb2hsv(newImg);
        transformed(:,:,1) = randi([1 360],1,1)/360;
        %transformed(:,:,2) = randi([0 50],1,1)/100;
        %transformed(:,:,3) = randi([0 100],1,1)/100;
        newImg = hsv2rgb(transformed);


        newImg = putAlpha(newImg, false, alphadirs(j).name);

        newImg = imresize(newImg, [randi([50 300],1,1) NaN]);

        newImg = backdrop(newImg);
        newImg = imgaussfilt(newImg, randi([3 5],1,1));

        imwrite(newImg , char(strcat(curdir,'\', alphadirs(j).name, " (", string(startingIndex), ").jpg")));

        startingIndex = startingIndex + 1;
    end
end 

fprintf(strcat('Done!\n'));