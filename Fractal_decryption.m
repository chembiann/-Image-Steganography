
function rgb6=Fractal_decryption(rgb3,rgb2)
% Decrypt the image
% figure(4);
sizeM = size(rgb2);
nn = sizeM(1);
mm = sizeM(2);
rgb4 = bitxor(uint8(rgb3),rgb2);
rgb5 = reshape(rgb4,mm*1,nn,1)';
rgb6 = reshape(rgb5,nn,mm,1);
% imshow(rgb6); 

% figure,imshow(rgb6)
% title('The decrypted image');
end