%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Encrypt,rgb2]=Encryption(I)
rgb=I;
% figure(1);
% imshow(rgb); 
% title('The original image');
sizeM = size(rgb);
nn = sizeM(1);
mm = sizeM(2);

% Transpose the Fractals
rgb0 = reshape(rgb,nn,mm*1,1)';
rgb1 = reshape(rgb0,nn,mm,1);
rgb2 = rgb1;

% Prepare the L shapes
medium = mean(mean(mean(rgb2)));
ceilin = round(sqrt((255-medium)*medium));
% This is the password
key1 = round(rand*25+4);
key2 = 2*key1;

% Process RGB in a loop
for ic = 1:1
 for ii = 1:nn
  for jj = 1:mm
    if mod(ii,key2*ic) < key1*ic 
       rgb2(ii,jj,ic) = mod(jj,ceilin);
           if mod(jj,key2*ic) < key1*ic
              rgb2(ii,jj,ic) = mod(ii,ceilin);
           else
              rgb2(ii,jj,ic) = mod(ceilin-ii,ceilin);
           end
    else
       rgb2(ii,jj,ic) = mod(ceilin-jj,ceilin); 
    end
  end
 end
end

% Encrypt the image
% figure(2);
% imshow(rgb2); 
% title('The fractal tromino ');
rgb3 = bitxor(rgb1,rgb2);
% figure(3);
% imshow(rgb3); 
% title('The encrypted image');
for i=1:size(I,3)
Encrypt(:,:,i)=hybridchencrypt(rgb3(:,:,i));
end
end
