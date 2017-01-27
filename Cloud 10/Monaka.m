function [lines] = Monaka( lines )
distThresh = 20;
thetaThresh = 8;
rhoThresh = 10;
l = length(lines);

a = 1;

while a <= l
    x1start = lines(a).point1(1);
    y1start = lines(a).point1(2);
    
    x1end = lines(a).point2(1);
    y1end = lines(a).point2(2);
    
    theta1 = lines(a).theta(1);
    
    rho1 = lines(a).rho(1);
    
    
    
    b = a + 1;
    
    while b <= l
        x2start = lines(b).point1(1);
        y2start = lines(b).point1(2);
        
        x2end = lines(b).point2(1);
        y2end = lines(b).point2(2);
        
        theta2 = lines(b).theta(1);
        
        rho2 = lines(b).rho(1);
        
        
        
        % if thetas are close
        if (abs(theta1 - theta2) < thetaThresh)
            thetas_close = true;
        else
            thetas_close = false;
        end
        
        if (abs(rho1 - rho2) < rhoThresh)
            rhos_close = true;
        else
            rhos_close = false;
        end
        
        % Determining lengths of segments
        lengtha = sqrt((x1start - x1end)^2 + (y1start - y1end)^2);
        lengthb = sqrt((x2start - x2end)^2 + (y2start - y2end)^2);
        
        
        % If a is longer than b
        if(lengtha > lengthb)
            if(thetas_close && rhos_close)
                lines(b) = [];
                b = b - 1;
                l = l - 1;
            end
        else % If b is longer than a
            if(thetas_close && rhos_close)
                lines(a) = [];
                l = l - 1;
            end
        end                    

        b = b + 1;
    end
    a = a + 1;
end