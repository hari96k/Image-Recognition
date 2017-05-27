function [ maxIndex, maxIndex2 ] = getMaxIndex( matrix, bins )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

hist_out = imhist(matrix, bins);
%figure; plot(hist_out);

%doesn't work, findpeaks doesn't get peak if it's at 0 or end index
%[peak, ind] = findpeaks(hist);
%array = [peak, ind];
%sort = sortrows(array, 1);
%disp(num2str(sort(end, 2)));
%maxIndex = sort(end, 2);

%get peaks from findpeaks
[peak, ind] = findpeaks(hist_out);
array = [peak,ind];

%findpeaks doesn't get the first or last element of an array so we manually
%add them
%first index
index1 = [hist_out(1), 1];
%last index
index2 = [hist_out(bins), bins];

%add to findpeaks results
array = [array; index1];
array = [array; index2];

%sorts results
sort = sortrows(array, 1);

%returns top two indices
maxIndex = sort(end, 2);
maxIndex2 = sort(end-1, 2);

end

