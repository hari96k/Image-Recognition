images_processed = cell(1,1);
while true,
    
    files = dir('images3/*.jpg')';
    
    for i = 1:length(files)
        for im = images_processed
            if strcmp(im,files(i).name) == 1,
                files(i) = [];
            end
        end
    end
    
    for file = files
        img_orig = imread(['images3/' file.name]);
        %imshow(img_orig);
        %figure()
        PerfectCell(img_orig, file.name)
        images_processed{end+1} = file.name;
    end
end