function [ maxIndex, maxIndex2 ] = getMaxIndex( matrix, bins)

hist_out = imhist(matrix, bins);

%get peaks from findpeaks
[peak, ind] = findpeaks(hist_out);
array = [peak,ind];

%findpeaks doesn't get the first or last element of an array so we manually add them
%first index
% index1 = [hist_out(1), 1];
index2 = [hist_out(bins), bins];

%add to findpeaks results
% array = [array; index1];          % Ignore the first index(we don't want to find pure black, which is used to depict the background)
array = [array; index2];

%sorts results
sort = sortrows(array, 1);

%returns top two indices
maxIndex = sort(end, 2);
try                                 % For rare cases when there is only one color/peak
maxIndex2 = sort(end-1, 2);
catch
    maxIndex2 = sort(end, 2);
end

end

