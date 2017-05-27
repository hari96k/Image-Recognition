function [color] = color(h,s,v)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
if (h >= 0 && h < 20) || (h >= 330 && h <= 360)
    if s <= 15
        color = 'white2';
    elseif v <= 16
        color = 'black';
    else
        color = 'red';
    end
elseif h >= 20 && h < 50
    color = 'orange';
elseif h >= 50 && h < 70
    color = 'yellow';
elseif h >= 70 && h < 170
    color = 'green';
elseif h >= 170 && h < 265
    color = 'blue';
elseif h >= 265 && h < 330
    color = 'purple';
else 
    color = 'cannot be determined';
end
end
