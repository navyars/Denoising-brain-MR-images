I = imread('brain.JPG');
In = imnoise(I,'gaussian',0,0.01);
%I = double(I);
%In = I+10*randn(size(I));
A = im2double(In);
w = 1;
w = ceil(w);
sigma_d = 3;
sigma_r = 0.1;

[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/(2*sigma_d^2));

dim = size(A);
B = zeros(dim);

for i = 1:dim(1)
   for j = 1:dim(2)
      
         iMin = max(i-w,1);
         iMax = min(i+w,dim(1));
         jMin = max(j-w,1);
         jMax = min(j+w,dim(2));
         Ix = A(iMin:iMax,jMin:jMax);

         H = exp(-(Ix-A(i,j)).^2/(2*sigma_r^2));

         F = (H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1));
       
         C(i,j) = sum(F(:).*Ix(:))/sum(F(:));
               
   end
end
In1 = im2double(In);
I1 = im2double(I);
psnr_noisy = psnr(In1,I1);
psnr_output = psnr(C,I1);
disp(psnr_noisy);
disp(psnr_output);