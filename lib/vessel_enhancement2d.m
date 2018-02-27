function [imres,immax,imsum] = vessel_enhancement2d(im,sl,no,sigma)
%%  vessel_enhancement2d - vessel enhancement filtering
%   
%   REFERENCE:
%       F. Zana, J. C. Klein, 
%       Segmentation of vessel-like patterns using mathematical morphology 
%       and curvature evaluation, IEEE Transactions on Image Processing, 
%       10, 7, 1010-1019, 2001
%
%   INPUT:
%       im      - 2D gray image
%       sl      - line size
%       no      - number of orientations
%       sigma   - Gaussian kernel sigma
%
%   OUTPUT:
%       imres   - segmentation
%       immax   - alternating filter 
%       imsum   - max of top-hats 
%
%   AUTHOR:
%       Boguslaw Obara
%

%% double to gray
im = im2uint8(im);
im = double(im);

%% opening by reconstruction
o = 0:180/no:180-180/no;

immax = zeros(size(im));
for i=1:length(o)
   se = strel('line',sl,o(i));
   imo = imopen(im,se);
   immax = max(immax,imo);
end
imop = imreconstruct(im,immax);

%% sum
imsum = zeros(size(im));
for i=1:length(o)
   se = strel('line',sl,o(i));
   imo = imopen(im,se);
   imsum = imsum + (imop - imo);
end

%% laplacian
h = fspecial('log',3*[sigma sigma],sigma);
imlap = imfilter(imsum,h,'same');
imlap = -imlap; % fix: vessels -> positive & edges -> negative

%% alternating filter 1
immax = -inf*ones(size(im));
for i=1:length(o)
   se = strel('line',sl,o(i));
   imo = imopen(imlap,se);
   immax = max(immax,imo);
end
im1 = imreconstruct(imlap,immax);

%% alternating filter 2
immin = inf*ones(size(im));
for i=1:length(o)
   se = strel('line',sl,o(i));
   imc = imclose(im1,se);
   immin = min(immin,imc);
end
im2 = imreconstruct(im1,immin);

%% alternating filter res
sl = 2*sl; % scaling factor e
immax = -inf*ones(size(im));
for i=1:length(o)
   se = strel('line',sl,o(i));
   imo = imopen(im2,se);
   immax = max(immax,imo);
end
imres = immax>=1;

end