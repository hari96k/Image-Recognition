S = imread('test_images/sobel1.jpg');

S = rgb2gray(S);
S = imfill(S,'holes');

   s = regionprops(S, 'centroid');
   centroids = cat(1, s.Centroid);
   imshow(S)
   hold on
   plot(centroids(:,1), centroids(:,2), 'b*')
   hold off