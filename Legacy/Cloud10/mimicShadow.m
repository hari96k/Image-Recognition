% Determines the new point to traverse through

function [ n_index ] = mimicShadow( xArray, yArray, avoidx, avoidy )

try
    
    if yArray(1) < avoidy
        selection = 1;        % FIND SHADOW UP
    end
    
    if yArray(1) >= avoidy
        selection = 0;        % FIND SHADOW DOWN
    end
    
    index = 5;
    
    y2 = yArray( index );
    x2 = xArray( index );
    
    deltay = y2-avoidy;
    deltax = x2-avoidx;
    
    if selection == 0
        while (y2 < yArray(1)) || sqrt((deltay)^2 + (deltax)^2) <= 10  || deltax < 0
            index = index + 1;
            
            y2 = yArray( index );
            x2 = xArray( index );
            
            deltay = y2-avoidy;
            deltax = x2-avoidx;
        end
        
    else if selection == 1
            while  y2 > yArray(1)  || sqrt(deltay^2 + deltax^2) <= 10 || deltax < 0
                index = index + 1;
                
                y2 = yArray( index );
                x2 = xArray( index );
                
                deltay = y2-avoidy;
                deltax = x2-avoidx;
            end
        end
    end
    
    if deltay > 150 || deltax > 150
        [n_index] = echoShadow( xArray, yArray, avoidx, avoidy );
    else
        n_index = index;
    end
    
catch
    [n_index] = echoShadow( xArray, yArray, avoidx, avoidy );
end

