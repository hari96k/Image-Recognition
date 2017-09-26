function [lines] = removeDuplicates( lines )
distThresh = 20;
thetaThresh = 5;
l = length(lines);

a = 1;

while a <= l
    x1start = lines(a).point1(1);
    y1start = lines(a).point1(2);
    
    x1end = lines(a).point2(1);
    y1end = lines(a).point2(2);
    
    theta1 = lines(a).theta(1);
    
    x1center = ( abs(x1start - x1end) )/2;
    y1center = ( abs(y1start - y1end) )/2;
    
    
    b = a + 1;
    
    while b <= l
        x2start = lines(b).point1(1);
        y2start = lines(b).point1(2);

        x2end = lines(b).point2(1);
        y2end = lines(b).point2(2);
        
        theta2 = lines(b).theta(1);
        
        x2center = ( abs(x2start - x2end) )/2;
        y2center = ( abs(y2start - y2end) )/2;
        
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
        
        
        % if centers are close
        if (sqrt((x1center - x2center)^2 + (y1center - y2center)^2) < distThresh)
            centers_close = true;
            lengtha = sqrt((x1start - x1end)^2 + (y1start - y1end)^2);
            lengthb = sqrt((x2start - x2end)^2 + (y2start - y2end)^2);
            if(lengtha > lengthb)
                major = a;
            else
                major = b;
            end
            
        else
            centers_close = false;
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
        elseif centers_close && thetas_close
            %%%%%%%%%%%%%%%%%%%%%%% FINISH THIS %%%%%%%%%%%%%%%%%%%%%%%%
        end
        
        b = b + 1;
    end
    a = a + 1;
end