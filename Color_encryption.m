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

%% Hybrid Transform
for p=1:3
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
    tic
    %% Secret image Encyption using  hybrid chaotic mapping with L-shaped fractal Tromino
    M=3;% 1 Fractal tromino / 2 Rubik's Cube principle / 3 Hybrid improved chaotic
    switch M
        case 1
            [Encrypted_img,I2] = Fractal_Encryption (Secret_Img(:,:,p));
            I(:,:,p)=I2;
        case 2
            [Encrypted_img,KR,KC,Itera_max] = Rubik_R_channel (double(Secret_Img(:,:,p)));
            opts(p).KR=KR;
            opts(p).KC=KC;
            opts(p).Itera_max=Itera_max;
        case 3
            [Encrypted_img] = hybrid_chaos_encrypt (Secret_Img(:,:,p));
    end
    opts(p).M=M;
    
    encryption_RGB(:,:,p)=Encrypted_img;
    toc
    watermark = de2bi(Encrypted_img);% Change in binary
    m1=LWT_block_img; % Sorce image in which watermark will be inserted
    m2=DWT_block_img;
    %% Blockwise embedding
    % wtmark function performs watermarking in DCT domain
    % it processes the image into 8x8 blocks.
    [embimg_1]=Blockwise_embedding(m1,watermark);
    [embimg_2]=Blockwise_embedding(m2,watermark);
    %% Processing stego image
    % Change 64 row cell in to particular columns to form image

    Stego_iwt(:,:,p) = ilwt2(double(embimg_1),h1,v1,d1,LS1);
    Stego_dwt(:,:,p) = idwt2(double(embimg_2),h,v,d,LS2{:});
end
%% Show Stego and Encrypted Image
figure,imshow(uint8(encryption_RGB)),title('Encrypted Secret Image')
figure,
subplot(1,2,1),imshow(uint8(LWT1),[]),title('Approximation matrix LWT')
subplot(1,2,2),imshow(uint8(DWT1),[]),title('Approximation matrix DWT')
figure,
subplot(1,2,1),imshow(uint8(Stego_iwt),[]),title('LWT based Stego Image')
subplot(1,2,2),imshow(uint8(Stego_dwt),[]),title('DWT based Stego Image')
%% Extracted secret image decryption using hybrid chaotic mapping with L-shaped fractal Tromino
if M==1
    figure,imshow(uint8(I)),title('Fractal tromino')
    
    for q=1:3
        [Reconstructed_secret1(:,:,q)]=Deembedding(Stego_iwt(:,:,q),LS1,I(:,:,q),1,opts(q));
        [Reconstructed_secret2(:,:,q)]=Deembedding(Stego_dwt(:,:,q),LS2,I(:,:,q),2,opts(q));
    end
elseif M==2 || M==3
    for q=1:3
        [Reconstructed_secret1(:,:,q)]=Deembedding(Stego_iwt(:,:,q),LS1,1,1,opts(q));
        [Reconstructed_secret2(:,:,q)]=Deembedding(Stego_dwt(:,:,q),LS2,1,2,opts(q));
    end
end

%% Show Output Image
figure,imshow(uint8(Reconstructed_secret1)),title('IWT based Decrypted Secret Image')
figure,imshow(uint8(Reconstructed_secret2)),title('DWT based Decrypted Secret Image')
%% Performance measures
disp('IWT result')
performance_clr(Secret_Image,Reconstructed_secret1,Cover_Imag,Stego_iwt)
% NCCperformance(Stego_iwt)% If you want to see the result of NCC use
% this command (ctrl+T)
disp('DWT result')
performance_clr(Secret_Image,Reconstructed_secret2,Cover_Imag,Stego_dwt)
% NCCperformance(Stego_dwt)% If you want to see the result of NCC use
% this command (ctrl+T)
disp('Noise result')
