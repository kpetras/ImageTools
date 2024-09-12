function filter = TriangFilter(im, orPeak, orWidth)
% function filter = TriangFilter(im, orPeak, orWidth)
%
% Creates triangular filter (1 at the center orientation, linearly ramping
% off to 0 at 22.5% from center). It first creates the filter, which is then rotated to overlap the correct center orientation. 
% This function is called by the function
% IncIm. The original image needs to be square.  
%
% im: original image 
% orPeak: central orientation of the filter band (gets a value of 1)
% orWidth: width of the filter band

% Get size center coordinates of original image
[n, m]=size(im); % extract size of original image
Grid = zeros(m,n); % create array of zeroes of the size of the original image. 
xCen = m/2; % get the center x coordinate
yCen = n/2; % get the center y coordinate

% Loop through the x coordinates along the radius and create a filter of
% the proper size
for iX = 1:xCen
   y = round(tan(orWidth/2)*iX); % get the width of the filter at the current value of x
   val = linspace(1,0,y); % divide the amplitude evenly over these y coordinates
   Grid(xCen+iX, [yCen+1:yCen+length(val)]) = val;% add these values to the grid array created previously
   Grid2 = fliplr(Grid); % add them also to the mirrored grid array
   filter = Grid + Grid2; % add both grid arrays
end

% Rotate the filter to match the indicated peak position
rotFilter = imrotate(filter, orPeak);

% Corrects increased image size as a result of rotation
dimDiff = size(rotFilter,1)-size(filter,1);
if dimDiff ~= 0
    filter = rotFilter(1:length(filter),1:length(filter));
    
else
    filter = rotFilter;
end


