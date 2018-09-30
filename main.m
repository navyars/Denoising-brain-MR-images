I = imread('brain.JPG');
In = imnoise(I,'gaussian',0,0.01);
%I = double(I);
%In = I+20*randn(size(I));

%get thresholds from a noisy image
thresh_In = multithresh(In,5);

%get granule size
G_S = [thresh_In(2)-thresh_In(1),thresh_In(3)-thresh_In(2),thresh_In(4)-thresh_In(3),256-thresh_In(5),thresh_In(1),thresh_In(5)-thresh_In(4)];
g = min(G_S)/2;

%Rough Entropy Threshold
t_new = RE_threshold(In,g,thresh_In(1));
T_RE(1) = t_new;
t_new = RE_threshold(In,g,thresh_In(2));
T_RE(2) = t_new;
t_new = RE_threshold(In,g,thresh_In(3));
T_RE(3) = t_new;
t_new = RE_threshold(In,g,thresh_In(4));
T_RE(4) = t_new;
t_new = RE_threshold(In,g,thresh_In(5));
T_RE(5) = t_new;

%To get REM
T = T_RE;
dim1 = size(In);
for r=1:dim1(1)
	for c = 1:dim1(2)
		I2(r,c) = 0;
	end
end	

for k = 1:5
for r=1:dim1(1)-1
	for c = 1:dim1(2)-1
		if (mod(r,2) == 1 && mod(c,2) == 1)
			if((In(r,c) <= T(k) && In(r+1,c) <=T(k) && In(r+1,c+1)<=T(k) && In(r,c+1) <= T(k)) || (In(r,c) > T(k) && In(r+1,c) >T(k) && In(r+1,c+1) > T(k) && In(r,c+1) > T(k)))
				I2(r,c) = 0;
				I2(r+1,c) = 0;
				I2(r+1,c+1) = 0;
				I2(r,c+1) = 0;
			else
				I2(r,c) = 1;
				I2(r+1,c) = 1;
				I2(r+1,c+1) = 1;
				I2(r,c+1) = 1;
			end		 
		end
	end
end	
end	

%To get class labels

for r=1:dim1(1)
	for c = 1:dim1(2)
		I1(r,c) = 0;
	end
end	

for k = 1:5
for r=1:dim1(1)-1
	for c = 1:dim1(2)-1
		if (mod(r,2) == 1 && mod(c,2) == 1)
			if((In(r,c) <= T(k) && In(r+1,c) <=T(k) && In(r+1,c+1)<=T(k) && In(r,c+1) <= T(k)) || (In(r,c) > T(k) && In(r+1,c) >T(k) && In(r+1,c+1) > T(k) && In(r,c+1) > T(k)))
				I1(r,c) = I1(r,c)*(10^(k-1)) + 0;
				I1(r+1,c) = I1(r+1,c)*(10^(k-1)) + 0;
				I1(r+1,c+1) = I1(r+1,c+1)*(10^(k-1)) + 0;
				I1(r,c+1) = I1(r,c+1)*(10^(k-1)) + 0;
			else
				I1(r,c) = I1(r,c)*(10^(k-1)) + 1;
				I1(r+1,c) = I1(r+1,c)*(10^(k-1)) + 1;
				I1(r+1,c+1) = I1(r+1,c+1)*(10^(k-1)) + 1;
				I1(r,c+1) = I1(r,c+1)*(10^(k-1)) + 1;
			end		 
		end
	end
end	
end	

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
   
         %Compute rho values
         K=zeros(size(Ix));
         for i1 = iMin:iMax
         	for j1 = jMin:jMax
                b = rho(i,j,i1,j1,I1,I2);
                K(i1,j1) = b;
         	end
         end
         
         K=K(iMin:iMax, jMin:jMax);
         F1 = (H.*G((iMin:iMax)-i+w+1,(jMin:jMax)-j+w+1));         
         F = F1.*K;
         B(i,j) = sum(F(:).*Ix(:))/sum(F(:));
               
   end
end
I1 = im2double(I);
In1 = im2double(In);
psnr_noisy = psnr(In1,I1);
psnr_output = psnr(B,I1);
disp(psnr_noisy);
disp(psnr_output);

