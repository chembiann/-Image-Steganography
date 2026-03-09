% Cover_Img  = Input Image
% Secret_Img = Watermark
% Stego      = Output Embedded image
% p          = PSNR of Embedded image
clc
close all
clear all
warning off
rng default
dbstop if error
addpath(genpath('.'))
%% Read input images
wt=imread('Monkey.tiff');%% Secret Image
% Read the image
Secret_Image=imresize(wt,[64 64]);
Cover_Im=imread('butterfly.ppm');
%% Show Input Images
figure,
subplot(1,2,1),imshow(wt),title('Secret image image')
subplot(1,2,2),imshow(Cover_Im),title('Cover Image')
Cover_Imag=imresize(Cover_Im,[4096 4096]);% Resize image %%Cover Image
Secret_Img = imresize(Secret_Image,[64 64]);% Resize  image
opts=[];

%% Secret image Encyption using Rubik's Cube principle, hybrid chaotic mapping and L-shaped fractal Tromino
% R Fractal tromino / G Hybrid improved chaotic / B Rubik's Cube principle
% map
%% Fractal Tromino encryption
[Encrypted_Frac,I2] = Fractal_Encryption (Secret_Img(:,:,1));
I(:,:,1)=I2;
%% Hybrid improved chaotic map
[Encrypted_ICM] = hybrid_chaos_encrypt1 (Secret_Img(:,:,2));
%% Rubik's cube principle
[Encrypted_RCP,KR,KC,Itera_max] = Rubik_R_channel (double(Secret_Img(:,:,3)));
opts.KR=KR;
opts.KC=KC;
opts.Itera_max=Itera_max;
encryption_RGB(:,:,1)=Encrypted_Frac;
encryption_RGB(:,:,2)=Encrypted_ICM;
encryption_RGB(:,:,3)=Encrypted_RCP;

for p=1:3
    %%  Transform
    Cover_Img=Cover_Imag(:,:,p);
    %% Integer Wavelet Transform
    LS1 = liftwave('cdf2.2','Int2Int');
    [lwt_img,h1,v1,d1]=lwt2(double(Cover_Img),LS1);
    %% DWT2
    LS2 ={'db1','mode','sym'};
    [dwt_img,h,v,d]=dwt2(double(Cover_Img),LS2{:});
    
    LWT1(:,:,p)=lwt_img;
    DWT1(:,:,p)=dwt_img;
    % Discrete cosine transform
    LWT_block_img=blkproc(lwt_img,[8,8],@dct2);% DCT of image using 8X8 block
    DWT_block_img=blkproc(dwt_img,[8,8],@dct2);% DCT of image using 8X8 block
    watermark = de2bi(encryption_RGB(:,:,p));% Change in binary
    m1=LWT_block_img; % Sorce image in which watermark will be inserted
    m2=DWT_block_img;
    %% Blockwise embedding
    % wtmark function performs watermarking in DCT domain
    % it processes the image into 8x8 blocks.
    [embimg1]=Blockwise_embedding1(m1,watermark);
    [embimg2]=Blockwise_embedding(m2,watermark);
    %% Processing stego image
    Stego_iwt(:,:,p) = ilwt2(double(embimg1),h1,v1,d1,LS1);
    Stego_dwt(:,:,p) = idwt2(double(embimg2),h,v,d,LS2{:});
end
%% Show Stego and Encrypted Image
figure,imshow(uint8(encryption_RGB)),title('Encrypted Secret Image')
figure,
subplot(1,2,1),imshow(uint8(LWT1),[]),title('Approximation matrix IWT')
subplot(1,2,2),imshow(uint8(DWT1),[]),title('Approximation matrix DWT')
figure,
subplot(1,2,1),imshow(uint8(Stego_iwt),[]),title('LWT based Stego Image')
subplot(1,2,2),imshow(uint8(Stego_dwt),[]),title('DWT based Stego Image')
%% Extracted secret image decryption using Rubik's Cube principle, hybrid chaotic mapping and L-shaped fractal Tromino

figure,imshow(uint8(I)),title('Fractal tromino')

for q=1:3
    opts.q=q;
    [Reconstructed_secret1(:,:,q)]=Deembedding1(Stego_iwt(:,:,q),LS1,I,1,opts,size(watermark,1));
    [Reconstructed_secret2(:,:,q)]=Deembedding1(Stego_dwt(:,:,q),LS2,I,2,opts,size(watermark,1));
end


%% Show Output Image
figure,imshow(uint8(Reconstructed_secret1)),title('IWT based Decrypted Secret Image')
figure,imshow(uint8(Reconstructed_secret2)),title('DWT based Decrypted Secret Image')
%% Performance measures
disp('IWT result')
performance_clr(Secret_Image,Reconstructed_secret1,Cover_Imag,Stego_iwt)
% this command (ctrl+T)
disp('DWT result')
performance_clr(Secret_Image,Reconstructed_secret2,Cover_Imag,Stego_dwt)
% this command (ctrl+T)

