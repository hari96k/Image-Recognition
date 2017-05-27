image = imread('bad4.jpg');
H = fspecial('gaussian');
img = imfilter(image, H, 'replicate');
figure; imshow(img); title('Gaussian Blur'); 
%img = imadjust(img,[0.5 0.6],[]);
minSizeCroppedAreas = 1500;

img = resizeImage(img, minSizeCroppedAreas);
boxes = cropByMSER(img, minSizeCroppedAreas);

for i=1:size(boxes)
    %create cropped image
    crop = imcrop(img, boxes(i,:));
%     crop
    %show cropped image
    crop = rgb2gray(crop);
    figure; imshow(crop);
    if i == 17
        imwrite(crop, strcat('crop',num2str(i+1),'.jpg'));
    end
    % Marr/Hildreth edge detection
% with threshold forced to zero
MH1 = edge(crop,'log',0.001,1.0);
MH2 = edge(crop,'log',0.001,2.0);
MH3 = edge(crop,'log',0.001,3.0);
MH4 = edge(crop,'log',0.001,4.0);

% form mosaic
EFGH = [ MH1 MH2; MH3 MH4];

%% show mosaic in Matlab Figure window
log = figure('Name','Marr/Hildreth: UL: s=1  UR: s=2  BL: s=3 BR: s=4');
iptsetpref('ImshowBorder','tight');
imshow(EFGH,'InitialMagnification',100);
ShapeClassifier( crop, EFGH );


% Canny edge detection
[C1, Ct1] = edge(crop,'canny',[],1.0);
[C2, Ct2] = edge(crop,'canny',[],2.0);
[C3, Ct3] = edge(crop,'canny',[],3.0);
[C4, Ct4] = edge(crop,'canny',[],4.0);

% Recompute lowering both automatically computed
% thresholds by fraction k
k = 0.80;
C1 = edge(crop,'canny',k*Ct1,1.0);
C2 = edge(crop,'canny',k*Ct2,2.0);
C3 = edge(crop,'canny',k*Ct3,3.0);
C4 = edge(crop,'canny',k*Ct4,4.0);

% form mosaic
ABCD = [ C1 C2; C3 C4 ];

% show mosaic in Matlab Figure window
canny = figure('Name','Canny: UL: s=1  UR: s=2  BL: s=3 BR: s=4');
iptsetpref('ImshowBorder','tight');
imshow(ABCD,'InitialMagnification',100);
ShapeClassifier( crop, ABCD );

% uncomment to write results to file
%imwrite(ABCD,'canny.pbm','pbm');
%imwrite(EFGH,'log.pbm','pbm');

    %if i == 7 || i == 8 || i == 3
    %imwrite(crop, strcat('crop',num2str(i+1),'.jpg'));
    %end
    
end

