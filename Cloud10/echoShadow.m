% Like mimicShadow, but used only for acute angled shapes

function [ n_index ] = echoShadow( xArray, yArray, avoidx, avoidy )

try
    
    index = 3;
    
    x2 = xArray( index );
    y2 = yArray( index );
    
    deltax = x2-avoidx;
    deltay = y2-avoidy;
    
    
    while  abs(deltay) >=5 || abs(deltax) <= 10
        
        index = index + 1;
        
        x2 = xArray( index );
        y2 = yArray( index );
        
        deltax = x2-avoidx;
        deltay = y2-avoidy;
    end
    
    
    if deltax > 150 || deltay > 150
        n_index = 0;
    else
        n_index = index;
    end
    
catch
    n_index = 0;
end

