
shapes = string(["Triangles", "Semi Circles", "Circles", "Quarter Circles"]);

%files = dir('trainingImagesRaw/Triangles/*.jpg');
%files = dir('trainingImagesRaw/Semi Circles/*.jpg');
%files = dir('trainingImagesRaw/Circles/*.jpg');
%files = dir('trainingImagesRaw/Quarter Circles/*.jpg');

se5 = strel('square', 5);
se3 = strel('square', 3);
se2 = strel('square', 2);

for s = 1:length(shapes)
    
    switch shapes(s)
        case 'Triangles'
            files = dir('trainingImagesRaw/Triangles/*.jpg');
        case 'Semi Circles'
            files = dir('trainingImagesRaw/Semi Circles/*.jpg');
        case 'Circles'
            files = dir('trainingImagesRaw/Circles/*.jpg');
        case 'Quarter Circles'
            files = dir('trainingImagesRaw/Quarter Circles/*.jpg');
    end
    
    for i = 1:length(files)
        
        %Check if img is already cooked
        %         switch shapes(s)
        %             case 'Triangles'
        %                 if exist(strcat('trainingImagesCooked/Triangles', '/',files(i).name), 'file') == 2
        %                     continue;
        %                 end
        %             case 'Semi Circles'
        %                 if exist(strcat('trainingImagesCooked/Semi Circles', '/',files(i).name), 'file') == 2
        %                     continue;
        %                 end
        %             case 'Circles'
        %                 if exist(strcat('trainingImagesCooked/Circles', '/',files(i).name), 'file') == 2
        %                     continue;
        %                 end
        %             case 'Quarter Circles'
        %                 if exist(strcat('trainingImagesCooked/Quarter Circles', '/',files(i).name), 'file') == 2
        %                     continue;
        %                 end
        %         end
        
        
        
        img = imread(strcat(files(i).folder, '\',files(i).name));
        
        %imgGray = rgb2gray(img);
        
        [~, ~, numberOfColorChannels] = size(img);
        if numberOfColorChannels > 1
            imgGray = rgb2gray(img);
        else
            imgGray = img; % It's already gray.
        end
        
        
        BWimg = edge(imgGray,'canny', .4);
        thisImageThick = imdilate(BWimg,se5);
        
        blobs = regionprops(thisImageThick, 'BoundingBox');
        
        blobAreas = regionprops(thisImageThick, 'area');       %Order the blobs by their area
        order = [blobAreas.Area];
        [~,idx]=sort(order, 'descend');
        blobs=blobs(idx);
        
        boundary = blobs(1).BoundingBox;
        
        %thisBlob = imcrop(BWimg, boundary + [-5 -5 10 10]);
        %thisBlob = imcrop(img, boundary + [-5 -5 10 10]);
        try
            thisBlob = imcrop(rgb2gray(img), boundary + [-5 -5 10 10]);
        catch
            thisBlob = imcrop(img, boundary + [-5 -5 10 10]);
        end
        
        %             [height, width] = size(thisBlob);
        %             %imshow(thisBlob);
        %             %     thisBlob = bwareaopen(thisBlob, 50);
        %             thisBlob = imdilate(thisBlob,se2);
        %
        %             %     if(width > height)
        %             %         thisBlob = imresize(thisBlob, [100 NaN]) ;
        %             %     else
        %             %         thisBlob = imresize(thisBlob, [NaN 100]) ;
        %             %     end
        %             %     if(strcmp(files(i).name, 'circle12.jpg'))
        %             %         x = 1;
        %             %     end
        %
        %             thisBlob = imfill(thisBlob, 'holes');
        %             thisBlob = bwareaopen(thisBlob, 20);
        %             thisBlob = bwperim(thisBlob, 8);
        %             thisBlob = imdilate(thisBlob,se2);
        
        
        switch shapes(s)
            case 'Triangles'
                imwrite(thisBlob , strcat('trainingImagesCooked/Triangles', '/',files(i).name));
            case 'Semi Circles'
                imwrite(thisBlob , strcat('trainingImagesCooked/Semi Circles', '/',files(i).name));
            case 'Circles'
                imwrite(thisBlob , strcat('trainingImagesCooked/Circles', '/',files(i).name));
            case 'Quarter Circles'
                imwrite(thisBlob , strcat('trainingImagesCooked/Quarter Circles', '/',files(i).name));
        end
        %imwrite(thisBlob , strcat('trainingImagesCooked/Triangles', '/',files(i).name));
        %imwrite(thisBlob , strcat('trainingImagesCooked/Semi Circles', '/',files(i).name));
        %imwrite(thisBlob , strcat('trainingImagesCooked/Circles', '/',files(i).name));
        %imwrite(thisBlob , strcat('trainingImagesCooked/Quarter Circles', '/',files(i).name));
        
    end
    
end

fprintf('Cooked!\n');



