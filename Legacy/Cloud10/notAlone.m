function [ TorF ] = notAlone( midx, midy, xarray, yarray, scale)

midx = ceil(midx);
midy = ceil(midy);

[limit,~] = size(xarray);

TorF = 0;                           % 0 - Alone; 1 - notAlone

for g = 1:limit
    if (( sqrt((xarray(g) - midx)^2 + (yarray(g) - midy)^2) < scale))
        TorF = 1;
        return;
    end
end