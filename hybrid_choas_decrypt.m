function [timg] = hybrid_choas_decrypt (em_out2)
r = 3.62;
x(1) = 0.7;
row = size(em_out2,1);
col = size(em_out2,2);
s = row*col;
%Creation of Logistic function
% for n=1:s-1
%     x(n+1) = r*x(n)*(1-x(n));
% end
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
% [so,in] = sort(x);
%Creation of diffusion key
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

% row = size(em_out2,1);
% col = size(em_out2,2);
timg=reshape(em_out2,1,[]);
% timg = bitxor(uint8(key),uint8(timg));
timg =bitxor(key,double(timg));
timg = timg(:);
for m = size(timg,1):-1:1
    
    t1 = timg(m);
    timg(m)=timg(in(m));
    timg(in(m))=t1;
    
end
%Decryption End
timg = reshape(timg,[row col]);
end