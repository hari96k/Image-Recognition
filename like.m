function like(im, hist, files , net)
% like function for shape classification using nueral networks
    hs = imhist(rgb2gray(imresize(im,[50 50])));
    cls = vec2ind(net(hs));
 
    [~, n] = size(hist);
    for i = 1 : n
        if(cls == vec2ind(net(hist(:, i))))
            figure('name', files(i).name);
            imshow(imread(['images/' files(i).name]))
        end
    end
end
