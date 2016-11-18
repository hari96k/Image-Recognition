function [lines] = removeDuplicates( lines )
distThresh = 20;
thetaThresh = 5;
l = length(lines);

a = 1;
starts_close = false;
ends_close = false;
thetas_close = false;

while a <= l
    x1start = lines(a).point1(1);
    y1start = lines(a).point1(2);
    
    x1end = lines(a).point2(1);
    y1end = lines(a).point2(2);
    
    theta1 = lines(a).theta(1);
    
    b = a + 1;
    
    while b <= l
        x2start = lines(b).point1(1);
        y2start = lines(b).point1(2);

        x2end = lines(b).point2(1);
        y2end = lines(b).point2(2);
        
        theta2 = lines(b).theta(1);
        
        % if starts are close
        if ( sqrt( (x2start - x1start)^2 + (y2start - y1start)^2 ) < distThresh )
            starts_close = true;
        else
            starts_close = false;
        end
        
        % if ends are close
        if ( sqrt( (x2end - x1end)^2 + (y2end - y1end)^2 ) < distThresh )
            ends_close = true;
        else
            ends_close = false;
        end
        
        
        % if thetas are close
        if (abs(theta1 - theta2) < thetaThresh)
            thetas_close = true;
        else
            thetas_close = false;
        end
        
        if (starts_close && ends_close)
            lines(b) = [];
            b = b - 1;
            l = l - 1;
        elseif starts_close && thetas_close
            lines(a) = [];
            a = a - 1;
            l = l - 1;
        elseif ends_close && thetas_close
            lines(b) = [];
            b = b - 1;
            l = l - 1;
        end
        
        b = b + 1;
    end
    a = a + 1;
end