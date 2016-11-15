%LineRep
%This algorithm can handle:
%   
%Notes: Should probably just change the draw lines to horzizontal/vertical
%lines
%% Image Selection and Processing
%Import image then convert to grayscale
I = imread('Rectangle.png');
ImgInfo = imfinfo('Rectangle.png');
I = rgb2gray(I);
%% Sobel edge detection
[~, threshold] = edge(I, 'sobel');
fudgeFactor = .5;
BWs = edge(I,'sobel', threshold * fudgeFactor);
se90 = strel('line', 3, 90);
se0 = strel('line', 3, 0);
BWsdil = imdilate(BWs, [se90 se0]);
BWdfill = imfill(BWsdil, 'holes');
BWnobord = imclearborder(BWdfill, 4);
seD = strel('diamond',1);
BWfinal = imerode(BWnobord,seD);
BWfinal = imerode(BWfinal,seD);
BWoutline = bwperim(BWfinal);
Segout = I;
Segout(BWoutline) = 255;
figure, imshow(BWoutline), title('outline');
%% Draw Lines
% Draw lines 
hold on
axis on
%**** # pixels between lines ****
linegap = 40;
%--------------------------------
%Permanent Variables
imwidth = ImgInfo.Width;
imheight = ImgInfo.Height;
%Temp Variables (Need to be restated for next statement)
w = ImgInfo.Width;
l = ImgInfo.Height;
y = 0;
b = 0;
%Plot lines
% This statement draws the positive slope lines
while l > -imheight
    plot([0 ,w],[l + imheight, y + imheight])
    l = l - linegap;
    y = y - linegap;
    m = (y - l) / (w - 0);
    %Store values of coordinates on line where = 1
    for x = 0:l
        ycoord = m * x + b;
    end    
    hold on
    b = b - 5;
end
w = ImgInfo.Width;
l = ImgInfo.Height;
y = 0;
b = 0;
% This statement draws the negative slope lines
while l < imheight * 3
    plot([0 ,w],[y - imheight, l - imheight])
    l = l + linegap;
    y = y + linegap;
    m = (y - l) / (w - 0);
    for x = 0:l
        ycoord = m * x + b;
        
    end    
    hold on
    b = b - 5;
end
%% Find intersections with edges
%Points that are on the edge = 1
%New Idea: make lines thicker, erase set all values on a line = 0


%% Draw lines that go through 4 or more points

%% Handle Exceptions for Circles/Semicircles

%Graph lines in xy coordinate planes

%Find intersections

%Find slopes of lines

%Calculate angles of corners (have to figure out how to find the right
%angle)

%Determine Shape using #corners on or off of blob/angles of corners/
%Implemented shapes - 
%Need to be implemented - Circle, Semicircle, Triangle, Square, Rectangle,
%Trapezoid, n-gon, cross, star