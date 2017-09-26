% Finds the neighbor of a point

function [ n_index, keepGoing ] = myNeighbor( xArray, yArray, index, selection )

if selection == 2
    selection = 0;                          %going down
elseif selection == 3
    selection = 1;                          %going up
end

limit = length(xArray);

last = max(yArray);

x1 = xArray(index);
y1 = yArray(index);

if index + 10 <= limit            % Checking that the start index is not too close to the end
    n_index = index + 5;
else
    keepGoing = 0;
    n_index = index;
    return;
end

x2 = xArray( n_index );
y2 = yArray( n_index );

deltax = x2-x1;
deltay = y2-y1;

keepGoing = 1;

if selection == 1                   % GOING UP
    if index > 5                    % This portion is for forced traversal directly upward
        if yArray(index-5) - yArray(index) == 0 && abs(xArray(index-5)- xArray(index)) < 20
            n_index = index - 5;
            
            x2 = xArray( n_index );
            y2 = yArray( n_index );
            
            deltax = x2-x1;
            deltay = y2-y1;
        end
    end
    
    while  ( sqrt(deltax^2 + deltay^2) > 25 && deltay ~= 0 ) || deltax > 0 || (deltax == 0 &&  sqrt(deltax^2 + deltay^2) < 10) || (deltay == 0 && sqrt(deltax^2 + deltay^2) > 10) || (deltay == 1 && sqrt(deltax^2 + deltay^2) > 10) || sqrt(deltax^2 + deltay^2) < 2
        
        n_index = n_index + 1;
        
        if n_index - index > 200 || n_index > limit || yArray(n_index) == last;
            keepGoing = 0;
            n_index = index;
            return;
        end
        
        x2 = xArray ( n_index );
        y2 = yArray ( n_index );
        
        deltax = x2-x1;
        deltay = y2-y1;
    end
    
else                            %GOING DOWN
    
    while  sqrt(deltax^2 + deltay^2) > 25 || deltax < 0 || (deltax == 0 &&  sqrt(deltax^2 + deltay^2) < 5) || (deltay == 0 &&  sqrt(deltax^2 + deltay^2) < 5) || sqrt(deltax^2 + deltay^2) < 2
        
        n_index = n_index + 1;
        
        if (n_index - index) > 200 || n_index > limit
            keepGoing = 0;
            n_index = index;
            break;
        end
        
        x2 = xArray ( n_index );
        y2 = yArray ( n_index );
        
        deltax = x2-x1;
        deltay = y2-y1;
    end
    
end