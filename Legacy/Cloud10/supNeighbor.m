% Finds the neighbor of a point

function [ n_index, keepGoing ] = supNeighbor( yArray, xArray, index, selection )

if selection == 2
    selection = 0;                          %going down
elseif selection == 3
    selection = 1;                          %going up
end

limit = length(yArray);

% last = max(xArray);

y1 = yArray(index);
x1 = xArray(index);

if index + 10 <= limit            % Checking that the start index is not too close to the end
    n_index = index + 5;
else
    keepGoing = 0;
    n_index = index;
    return;
end

y2 = yArray( n_index );
x2 = xArray( n_index );

deltay = y2-y1;
deltax = x2-x1;

count = 1;
options = zeros([15 1]);
distance = zeros([15 1]);

keepGoing = 1;
offset = 5;

while count <= 10
    if selection == 1                   % GOING UP
        if index > offset       % This portion is for forced traversal directly upward
            if xArray(index-offset) - xArray(index) == 0 && abs(yArray(index-offset)- yArray(index)) < 20
                n_index = index - 5;
                y2 = yArray( n_index );
                x2 = xArray( n_index );
                
                deltay = y2-y1;
                deltax = x2-x1;
            end
        end
        
        %       Max neighbor distance at 50
        while  ( sqrt(deltay^2 + deltax^2) > 50 && deltax ~= 0 ) || deltay > 0 || (deltax == 0 && deltay > 20) || (deltax == 1 && sqrt(deltay^2 + deltax^2) ) || (deltay == 0 && deltax < 15) || sqrt(deltay^2 + deltax^2) < 2
            
            n_index = n_index + 1;
            
            if n_index - index > 300 || n_index > limit ; %|| xArray(n_index) == last
                keepGoing = 0;
                n_index = index;
                return;
            end
            
            y2 = yArray ( n_index );
            x2 = xArray ( n_index );
            
            deltay = y2-y1;
            deltax = x2-x1;
        end
        
    else                            %GOING DOWN
        
        while  sqrt(deltay^2 + deltax^2) > 50 || deltay < 0 ||  (deltax == 0 &&  deltay < 15) || sqrt(deltay^2 + deltax^2) < 2 || (deltay == 0 && deltax < 15)
            
            n_index = n_index + 1;
            
            if (n_index - index) > 300 || n_index > limit
                keepGoing = 0;
                n_index = index;
                break;
            end
            
            y2 = yArray ( n_index );
            x2 = xArray ( n_index );
            
            deltay = y2-y1;
            deltax = x2-x1;
        end
        
    end
    
    options(count) = n_index;
    distance(count) = sqrt(deltay^2+deltax^2);
    count = count + 1;
    offset = offset + 1;
    n_index = n_index + 1;
    
    
    if n_index <= limit
        y2 = yArray ( n_index );
        x2 = xArray ( n_index );
        
        deltay = y2-y1;
        deltax = x2-x1;
    end
    
end

another = distance(distance ~= 0);
[~, m_index] = min(another);
n_index = options(m_index);

