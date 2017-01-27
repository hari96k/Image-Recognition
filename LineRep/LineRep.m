%LineRep
%This algorithm can handle:
%   
%Notes: 
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
linegap = 44;
%--------------------------------
%Permanent Variables
imwidth = ImgInfo.Width;
imheight = ImgInfo.Height;
%Temp Variables (Need to be restated for next statement)
w = ImgInfo.Width;
h = ImgInfo.Height;
linex = 1;
liney = 1;
IntersectionArray = [];
%Plot lines
% This statement draws the horizontal lines
while liney < imheight
    plot([1 ,w],[liney, liney])
    %Store values of coordinates on line where = 1
    for i = 1:w;
        if BWoutline(liney, i) == 1;
            IntersectionArray = [IntersectionArray ; [i, liney]];
        end
    end 
    liney = liney + linegap;
    hold on
end
% This statement draws the vertical lines
while linex < imwidth
    plot([linex ,linex],[1, imheight])
    %Store values of intersections
    for j = 1:h;
        if BWoutline(j, linex) == 1;
            IntersectionArray = [IntersectionArray ; [linex, j]];
        end
    end  
    linex = linex + linegap;
    hold on
end
%% Draw lines that go through 4 or more points

%A = numel(IntersectionArray) / 2;
% B = 0;
% while A > 0
%     B = B + A;
%     A = A - 1;
% end
% C = IntersectionArray;
% D = 1;
% E = 1;
% while D < numel(IntersectionArray) / 2
%     for D 
%while B > 0
%    for
%    B = B - 1;
%end

%%Calculate equation for line on each point  
NumCoordinates = numel(IntersectionArray) / 2;
A = 1;
numiter = 2;
LineEqArray = [];
while A <= NumCoordinates;
    x1 = IntersectionArray(A,1);
    y1 = IntersectionArray(A,2);
    for alpha = numiter:numcoordinates;
        x2 = IntersectionArray(alpha,1);
        y2 = IntersectionArray(alpha,2);
        m = (y2 - y1)/(x2 - x1);
        b = y1 - m*x1;
        for beta = 1:NumCoordinates;
            pc = 0;
            if IntersectionArray(beta,2) = m*IntersectionArray + b
                pc = pc + 1;
            end
            if pc = 4;
                LineEqArray = [LineEqArray ; [m,b]];
                break
            end
        end
        
    end 
    numiter = numiter + 1;
end 
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