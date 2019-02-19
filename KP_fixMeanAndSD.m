function [ imout ] = KP_fixMeanAndSD( imin, Mean, SD )
%takes an image, a desired mean and a desired SD. Will adjust the image to
%have this mean and this SD. Defaults to mean=0.5 and SD 0.1

if nargin<3
    SD = 0.1;
end
if nargin<2
    Mean = 0.5;
end

temp    = imin./std2(imin);
temp    = temp - mean2(imin);
temp    = temp .*SD;
imout   = temp + Mean;
end

