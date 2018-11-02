%read image
im=(im2double(imread('Trumpet.bmp')));
im = rgb2gray(im);

%make fourier transform
imf=fftshift(fft2(im));
imf=abs(imf).^2;

N = size(im);
f=-N/2:N/2-1;
figure;
imagesc(f,f,log10(imf)), axis xy
Pf=rotavg(imf); % get rotational average

f1=0:N/2;
figure;
Pf = Pf(3:N/2);
f1 = f1(3:N/2);
semilogy(f1,Pf);
%%
AuC=trapz(Pf, f1); % get the area under the curve
LSF = 0;
halfAuC = .5* AuC;
cutoff = 0.1;
z=2;
while LSF>halfAuC
    f2= f1(1:z);
    LSF=trapz(Pf(1:z), f2); % get the area under the curve
    z = z+1;
end


