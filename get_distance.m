%function [ output_args ] = get_distance(matrix)

% Rows 4 - 10 were a test to see if a circle would give a straight line
% It works
x_top = linspace(-1, 1, 360);
y_top = sqrt(1 - x_top.^2);
x_bot = -x_top;
y_bot = -y_top;
x_total = [x_top x_bot];
y_total = [y_top y_bot];
matrix = [x_total ; y_total];

[x, y] = size(matrix);

summ_x = 0;
summ_y = 0;
x_center = 0;
y_center = 0;

%This assumes the input data is a 2d array of form 2xn or nx2
%double-check hari's code later
if x > y
    for i = 1:x
        summ_x = summ_x + matrix(i,1);
        summ_y = summ_y + matrix(i,2);
    end
    x_center = summ_x / x;
    y_center = summ_y / x;
    
    %using distance formula to fidn the length r from the center to the
    %point
    distance_arr = zeros(1,x);
    for i = 1:x
        distance_arr(i) = sqrt((x_center - matrix(i,1))^2 + ...
            (y_center - matrix(i,2))^2);
    end
    
    %plots the data
    figure(1);
    title('Distance vs Index');
    plot(1:x, distance_arr, 'r-')
    
elseif y > x
    for i = 1:y
        summ_x = summ_x + matrix(1,i);
        summ_y = summ_y + matrix(2,i);
    end
    x_center = summ_x / y;
    y_center = summ_y / y;
    
    %using distance formula to fidn the length r from the center to the
    %point
    distance_arr = zeros(1,y);
    for i = 1:y
        distance_arr(i) = sqrt((x_center - matrix(1,i))^2 + ...
            (y_center - matrix(2,i))^2);
    end
    
    %plots the data
    figure(1);
    title('Distance vs Index');
    plot(1:y, distance_arr, 'r-')
end

%end