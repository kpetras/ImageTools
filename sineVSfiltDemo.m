sizeInPix = 500;
SpatFreq = sizeInPix/15.5; %SF in pix/degree
contrast = 0.5;

orientation = 90;
X = ones(sizeInPix,1)*[-(sizeInPix-1)/2:1:(sizeInPix-1)/2];
Y =[-(sizeInPix-1)/2:1:(sizeInPix-1)/2]' * ones(1,sizeInPix);

%make a template sine grating image
sinIm = contrast .* sin((2.*pi)/SpatFreq.* (cos(deg2rad(orientation)).*X ...
    + sin(deg2rad(orientation)).*Y));

FFT = fftshift(fft2(sinIm));
figure;
imshow(sinIm,[]);
title('sinIm');

figure;
fl = log(1+abs(FFT));
fm = max(fl(:));
imshow(im2uint8(fl/fm))
title('orginal FFT')

%make FFT mask with triangular + Butterworth
% triangle Filter
thetaSig=45; % Width of the orientation band in degrees
triangFilter = TriangFilter(sinIm, orientation-90, thetaSig); % creates triangular filter (1 at the center orientation, ramping off to 0 at 22.5% from center)

% Create a mirror image of the filter
mirrFilter = flip(triangFilter,1); 
mirrFilter = flip(mirrFilter,2);
triangFilter = triangFilter + mirrFilter;

%make bandpass
order =4;
cutoff = [SpatFreq-1, SpatFreq+1];
L = size(sinIm);
% Computes the distance grid
dist = zeros(L, 'double');
m = L(1) / 2 + 1;
for i = 1:L(1)
    for j = 1:L(1)
        dist(i, j) = sqrt((i - m)^2 + (j - m)^2);
    end
end


% Create Butterworth filter.
LP = 1 ./ (1 + (dist / cutoff(1)).^(2 * order));
HP = 1 ./ (1 + (dist / cutoff(2)).^(2 * order));

HPFilter = (1.0 - HP) ;
LPFilter = (1.0 ) .* LP;
BPFilter  = 1 - LP;
BPFilter = HP .* BPFilter;

%combine filters
filter = triangFilter .* BPFilter;
figure; imshow(filter)
title('filter')

%make image
newFFT = (abs(FFT).* filter).* exp(sqrt(-1)*(angle(FFT)));
figure; fl = log(1+abs(newFFT));
fm = max(fl(:));
imshow(im2uint8(fl/fm))
title('filtered Spectrum')
newIm = real(ifft2(ifftshift(newFFT)));
figure; imshow(newIm,[]);
title('im made from filter')


