function [himg] = hybrid_chaos_encrypt (mask)
img=mask;
timg = img;
r = 3.62;
x(1) = 0.7;
row = size(img,1);
col = size(img,2);
s = row*col;
lamda=2.741;
beta=0.021;
alpha=0.041;
c=0.9;X(1)=0.790;Y(1)=0.889;Z(1)=0.590;
T=0.1;
U=0.1;
V=0.1;
%Creation of 3D Logistic function
for n=1:s-1
%     x(n+1) = r*x(n)*(1-x(n));
T(n+1) = alpha * T(n) * (1-T(n)) + lamda * U(n)^2 * T(n) + beta * V(n)^3 ;
U(n+1) = alpha * U(n) * (1-U(n)) + lamda * V(n)^2 * U(n) + beta * T(n)^3 ;
V(n+1) = alpha * V(n) * (1-V(n)) + lamda * T(n)^2 * V(n) + beta * U(n)^3 ;
end

for n=1:s-1
%     x(n+1) = r*x(n)*(1-x(n));
X(n+1) = -lamda * T(n) * (1-X(n)) + beta * Y(n)^2 * X(n) + alpha * Z(n)^3 + c;
Y(n+1) = -lamda * U(n) * (1-Y(n)) + beta * V(n)^2 * Y(n) + alpha * X(n)^3 + c;
Z(n+1) = -lamda * Z(n) * (1-Z(n)) + beta * X(n)^2 * Z(n) + alpha * Y(n)^3 + c;
end
[so,in] = sort(X);
%Start of Confusion
timg = timg(:);
for m = 1:size(timg,1)  
    t1 = timg(m);
    timg(m)=timg(in(m));
    timg(in(m))=t1;
end
%End of confussion
%Creation of diffusion key using henon map
e(1)=0.4;
l(1)=0.4;
a=1.4;
b=0.3;
for n=1:s-1
    e(n+1) = 1-((a*e(n)^2)+l(n));
    l(n+1) = b*e(n);
end
k = abs(round(e*255));
% k = abs(round(k*255));
ktemp = de2bi(k);
ktemp = circshift(ktemp,1);
ktemp = bi2de(ktemp)';
key = bitxor(k,ktemp);
%Ending creation of diffusion key
%Final Encryption Starts
timg = timg';
timg = bitxor(key,double(timg));
himg = reshape(timg,[row col]);
end