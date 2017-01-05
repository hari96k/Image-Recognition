function [ shape ] = Whis( lines )
%Shape Classification based on hough lines (found by Beerus)
shape = 'Unknown';

if(length(lines) <= 2)
    return;
    % Checking for triangle
end


bigAngles = 0;
perpAngles = 0;
thetaGap = 8;
perpGap = 70;


if abs(lines(1).theta - lines(2).theta) > thetaGap
    bigAngles = bigAngles + 1;
    if abs(lines(1).theta - lines(2).theta) > perpGap
        perpAngles = perpAngles + 1;
    end
end

if abs(lines(2).theta - lines(3).theta) > thetaGap
    bigAngles = bigAngles + 1;
    if abs(lines(2).theta - lines(3).theta) > perpGap
        perpAngles = perpAngles + 1;
    end
end

if abs(lines(1).theta - lines(3).theta) > thetaGap
    bigAngles = bigAngles + 1;
    if abs(lines(1).theta - lines(3).theta) > perpGap
        perpAngles = perpAngles + 1;
    end
end

if(length(lines) == 3)
    if(bigAngles == 3)
        shape = 'Triangle';
    end
    
elseif(length(lines) == 4)
    if abs(lines(1).theta - lines(4).theta) > thetaGap
        bigAngles = bigAngles + 1;
        if abs(lines(1).theta - lines(4).theta) > perpGap
            perpAngles = perpAngles + 1;
        end
    end
    
    if abs(lines(2).theta - lines(4).theta) > thetaGap
        bigAngles = bigAngles + 1;
        if abs(lines(2).theta - lines(4).theta) > perpGap
            perpAngles = perpAngles + 1;
        end
    end
    
    if abs(lines(3).theta - lines(4).theta) > thetaGap
        bigAngles = bigAngles + 1;
        if abs(lines(3).theta - lines(4).theta) > perpGap
            perpAngles = perpAngles + 1;
        end
    end

if(perpAngles == 4)
    shape = 'Rectagle';
end
end

