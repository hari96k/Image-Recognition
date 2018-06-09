%% IMAGE SELECTION

img_bad = imread('images/test/bad2.jpg');         % tringle in bad4.jpg fails (bump on top side causes problems with neighbor detection)
% img_crop = imread('images/test/crop.jpg');        % crop2.jpg fails (corners are missing due to crop)
img_test = imread('images/test/test.jpg');
% img_square = imread('images/test/square.jpg');
% img_difficult = imread('images/test/IMG_2376.jpg');
% img_rectangle = imread('images/test/rectangle3.jpg');
% img_barelyRectangle = imread('images/test/barelyRectangle.jpg');
% img_star = imread('images/test/star.jpg');
 img_cross = imread('images/test/cross2.jpg');
% img_trap = imread('images/test/trap.png');
img_nothing = imread('images/test/nothing3.jpg');
img_DBZ = imread('images/test/DBZ.png');
% img_potato = imread('images/test/potato.jpg');
% img_texas = imread('images/test/texas.jpg');
% img_circle = imread('images/test/circle.png');     % circle.png fails (it's poles are missing)
% img_semi = imread('images/test/semi14.jpg');        % semi12 / semi13.jpg fail (it's complicated...)
% img_quart = imread('images/test/quart7.jpg');
% img_tringle = imread('images/test/tringle14.jpg');
% img_shear = imread('images/test/shear7.jpg');
 img_impossible = imread('images/test/impossible.jpg');  % Too much god damn noise
% img_qr = imread('images/test/qr2.jpg');
% img_test = imread('images/test/cross4.jpg');
img_comp = imread('images_Final/image-100.jpg');

% ******* Change the img assignment to debug with another image *******

img = img_comp;


% ******* Select Appropriate Modes *******

mode = 1;       % 0 - Fast/Performance Mode     1 - Debugging Mode (Shows Approximations)

writeEnable = 0;   % 0 - No Write               1 - Shape written on disk

% Use mode 0 and writeEnable 1 for competition =)

%% PRE-IMAGE PROCESSING
% Standard for all images(no initial crop)

close all;

% Best/Optimal Pre-Processing
filter = .18;
interEdges = coloredges(img);
interEdges = interEdges / max(interEdges(:));

% Special Crop to fix ffmpeg capture
topCut = 10;
bottomCut = 12;
leftCut = 10;
rightCut = 10;
[height, width] = size(interEdges);

interEdges = imcrop(interEdges,[leftCut topCut width-leftCut-rightCut height-bottomCut-topCut] );
img = imcrop(img,[leftCut topCut width-leftCut-rightCut height-bottomCut-topCut] );
imgGray = rgb2gray(img);

BWimgMask = edge(interEdges,'canny', .3);
BWimg = edge(imgGray,'canny', .2);
%BW = imbinarize(interEdges, .05);

% Used to fill small holes/discontinuities
se10 = strel('square', 10);
se5 = strel('square', 5);
se3 = strel('square', 3);
se2 = strel('square', 2);

% thisImageThick is used to determine the boundary of a blob after dilating to fill holes (not displayed though)
thisImageThick = imdilate(BWimgMask,se5);


% Caps the filtered image to max 20 blobs
noiseLVL = 1;

blobs = regionprops(thisImageThick, 'BoundingBox');

while length(blobs) > 10
    thisImageThick = bwareaopen(thisImageThick, 200*noiseLVL);
    noiseLVL = noiseLVL + 1;
    blobs = regionprops(thisImageThick, 'BoundingBox');
end



z = 1;
%% LOOPING THROUGH BLOBS
while z <= length(blobs)
    boundary = blobs(z).BoundingBox;
    
    % Crop it out of the original gray scale image.
    thisBlob = imcrop(BWimg, boundary + [-3 -3 6 6]);
    numberOfWhite = sum(thisBlob(:));
    
    if numberOfWhite < 80
        z = z + 1;
        continue;
    end
    
    [height, width] = size(thisBlob);
    %     imshow(thisBlob);
    %    thisBlob = bwareaopen(thisBlob, 50);
    thisBlob = imdilate(thisBlob,se2);
    if(width > height)
        thisBlob = imresize(thisBlob, [100 NaN]) ;
    else
        thisBlob = imresize(thisBlob, [NaN 100]) ;
    end
    thisBlob = imfill(thisBlob,'holes');
    %    thisBlob = bwmorph(thisBlob, 'thin', Inf);
    thisBlob = bwperim(thisBlob, 8);
    thisBlob = imdilate(thisBlob,se3);
    
    %     figure;
    %     imshow(thisBlob);
    %     hold on;
    
    [H,T,R] = hough(thisBlob);
    
    %     figure;
    %     imshow(H,[],'XData',T,'YData',R,...
    %                 'InitialMagnification','fit');
    %     xlabel('\theta'), ylabel('\rho');
    %     axis on, axis normal, hold on;
    
    
    P  = houghpeaks(H,5,'threshold',ceil(.3*max(H(:))));
    x = T(P(:,2)); y = R(P(:,1));
    %     plot(x,y,'s','color','white');
    
    
    lines = houghlines(thisBlob,T,R,P,'FillGap',20,'MinLength',15);
    %[lines] = removeDuplicates(lines);
    [lines] = Monaka(lines);
    figure, imshow(thisBlob), hold on
    max_len = 0;
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');
        
        % Plot beginnings and ends of lines
        plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
        plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');
        
        % Determine the endpoints of the longest line segment
        len = norm(lines(k).point1 - lines(k).point2);
        if ( len > max_len)
            max_len = len;
            xy_long = xy;
        end
    end
    
    
    z = z + 1;
    shape = Whis(lines);
    if(strcmp(shape, 'Unknown'))
        close;
    else
        title(Whis(lines));
    end
    
end




