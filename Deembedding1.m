function [timg]=Deembedding1(embimg,LS,I2,Transform,opts,K1)
% Extarction
% exwmark will extract the watermark which were
% embedded by the wtmark function

% embimg    = Embedded image
% wm        = Extracted Watermark

%% Inter wavelet transform
switch Transform
    case 1
        [embimg1,~,~,~]=lwt2(double(embimg),LS);
    case 2
        [embimg1,~,~,~]=dwt2(double(embimg),LS{:});
end
[row, clm]=size(embimg1);
m=(embimg1);
% m=embimg;
%%%%%%%%%%%%%%%%% To divide image in to 4096---8X8 blocks %%%%%%%%%%%%%%%%%%
k=1; dr=0; dc=0;
% dr is to address 1:8 row every time for new block in x
% dc is to address 1:8 column every time for new block in x
% k is to change the no. of cell
for ii=1:8:row % To address row -- 8X8 blocks of image
    for jj=1:8:clm % To address columns -- 8X8 blocks of image
        for i=ii:(ii+7) % To address rows of blocks
            dr=dr+1;
            for j=jj:(jj+7) % To address columns of block
                dc=dc+1;
                z(dr,dc)=m(i,j);
            end
            dc=0;
        end
        x{k}=z; k=k+1;
        z=[]; dr=0;
    end
end
nn=x;

%% Extract water mark %%
wm=[]; wm1=[]; k=1; wmwd=[]; wmwd1=[];
while(k<32769)
    for i=1:4096
        kx=x{k}; % Extracting Blocks one by one
        dkx=blkproc(kx,[8 8],@dct2); % Applying Dct
        nn{k}=(dkx); % Save DCT values in new block to cross check
        
        %% Change me for pixel location
        wm1=[wm1 dkx(8,8)]; % Forming a row of 32 by 8,8 element
        
        % Extracting water mark without dct
        wmwd1=[wmwd1 kx(8,8)];
        k=k+1;
    end
    wm=[wm;wm1]; wm1=[]; % Forming columns of 32x32
    wmwd=[wmwd;wmwd1]; wmwd1=[];
end
%% Extracting the embedded secret image from stego image
for i=1:8
    for j=1:4096
        diff=wm(i,j);
        if diff >=0
            wm(i,j)=0;
        elseif diff < 0
            wm(i,j)=1;
        end
    end
end


wm=wm';
wm1=reshape(bi2de(wm),[64 64]);
tic
q=opts.q;
switch q
    case 1
        [timg(:,:,:)] = Fractal_decryption (wm1,I2);
    case 2
        [timg(:,:,:)] = hybrid_choas_decrypt1 (wm1);
    case 3
        [timg] = decrypt_Rubik_Rchannel (wm1,opts);
end

toc
