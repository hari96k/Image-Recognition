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

[peak, ind] = findpeaks(hist_out);
array = [peak,ind];
index1 = [hist_out(1), 1];
%lastArray = [lastSize, lastInd]
index2 = [hist_out(bins), bins];
array = [array; index1];
array = [array; index2];
sort = sortrows(array, 1);
maxIndex = sort(end, 2);
maxIndex2 = sort(end-1, 2);

% maxSize = 0;
% maxIndex = 0;
% %maxSize2 = 0;
% maxIndex2 = 0;
% 
% for i=1:size(hist_out)
%         if (hist_out(i) > maxSize)
%            maxSize = hist_out(i);
%            maxIndex = i;
%         end
% end
%disp(num2str(maxIndex)+ ' ' + num2str(maxIndex2));



end

