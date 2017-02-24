%% Insert distance algorithm here
    %dummy distance
dist = zeros(2,100);
n = length(dist);
thresh = 2;

%% Get number of corners
% 1st row: distance, 2nd row: index in "dist"
% 3rd row: 1 peak, 2 for valley
numCorn = [0;0;0];
numSide = 0;

% tells which surrounding indices the point is larger / smaller than
surr_l = zeros(1, 2*thresh);
surr_s = zeros(1, 2*thresh);
num_l = 0;
num_s = 0;

% insert last 2 elements in front, and first to elements in back for 
% simplicity when looping through for distance comparison
A = [dist(1, n - thresh + 1 : n) dist(1,:) dist(1, 1 : thresh); ...
            dist(2, n - thresh + 1 : n) dist(2,:) dist(2, 1 : thresh)];

for i = 1 + thresh : n + thresh
    %check indices before i
    for j = thresh : -1 : 1
        if A(1, i) > A(1, i-j)
            surr_l(thresh - j + 1) = 1;
            num_l = num_l + 1;
        elseif A(1, i) < A(1, i-2)
            surr_s(thresh - j + 1) = 1;
            num_s = num_s + 1;
        end
    end

    %check indices after i
    for j = 1 : thresh
        if A(1, i) > A(1, i+j)
            surr_l(thresh + j) = 1;
            num_l = num_l + 1;
        elseif A(1, i) < A(1, i+j)
            surr_s(thresh + j) = 1;
            num_s = num_s + 1;
        end
    end

    %Determine if it is actually a corner.
    %Multiple points around it are checked in case of noise, bad
    %measurements, and data loss during image processing
    if num_l >= thresh * 2/3
        numCorn = [A(1,i) numCorn(1,:); i numCorn(2,:); 1 numCorn(3,:)];
        numSide = numSide + 1;
    elseif num_s >= thresh * 2/3
        numCorn = [A(1,i) numCorn(1,:); i numCorn(2,:); 2 numCorn(3,:)];
        numSide = numSide + 1;
    end
       
    surr_l(:) = 0;
    surr_s(:) = 0;
    num_l = 0;
    num_s = 0;
end
numCorn = numCorn(:, 1 : end - 1);

%% Classify shapes based on corners and sides
% Square
if size(numCorn, 2) == 8 || c