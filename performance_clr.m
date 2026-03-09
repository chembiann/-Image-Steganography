function performance_clr(Secret_Img,Reconstructed_secret,Cover_Img1,Stego_img)
%% For Secret image
PSNR_=psnr(uint8(Secret_Img),uint8(Reconstructed_secret));%PSNR
E = entropy(uint8(Reconstructed_secret));%ENTROPY
for c=1:3
    ssimval = ssim(double(Secret_Img(:,:,c)),double(Reconstructed_secret(:,:,c)));%SSIM
    NCC=normxcorr2(double(Secret_Img(:,:,c)),double(Reconstructed_secret(:,:,c)));%%new
    NC(c)=max(max(NCC));
    SSIM(c)=ssimval;
end
NCC=max(NC);%NCC
ssimval=mean(SSIM);
results = NPCR_and_UACI( uint8(Secret_Img), uint8(Reconstructed_secret), 1, 255 );
UACI=results.uaci_dist(1)*100;%UACI unified averaged changed intensity 
NPCR=results.npcr_dist(1)%Npc number of changing pixel rate
% fprintf('Secret image PSNR = %f .\n',PSNR)
% fprintf('Secret image ssim = %f .\n',ssimval)
% fprintf('Secret image UACI = %f .\n',UACI)
% fprintf('Secret image entropy = %f .\n',E)
% fprintf('Secret image NC = %.4f .\n',NCC)
% fprintf('Secret image NPCR = %.4f .\n',NPCR)
Secret=[PSNR_;E;ssimval;NCC;UACI;NPCR];
%% For cover image
PSNR1=psnr(uint8(Cover_Img1),uint8(Stego_img));%PSNR
for c=1:1
    ssimval = ssim(double(Cover_Img1(:,:,c)),double(Stego_img(:,:,c)));%SSIM
    NCC=normxcorr2(double(Cover_Img1(:,:,c)),double(Stego_img(:,:,c)));%%new
    NC(c)=max(max(NCC));
    SSIM(c)=ssimval;
end
NCC1=max(NC);%NCC
ssimval1=mean(SSIM);
results = NPCR_and_UACI( uint8(Cover_Img1), uint8(Stego_img), 1, 255 );
UACI1=results.uaci_dist(1)*100;%UACI
NPCR1=results.npcr_dist(1)%Npc
E = entropy(uint8(Cover_Img1));%ENTROPY
Cover=[PSNR1;E;ssimval1;NCC1;UACI1;NPCR1];
Results=[Cover,Secret];
performer={  'Cover_image' 'Secret_image'};
Parameters={'PSNR'  'E' 'NCC' 'SSIM' 'UACI' 'NPCR'};
Results_table=array2table(Results,'VariableNames',performer,'RowNames',Parameters)
% disp('......')
% fprintf('Cover image PSNR = %f .\n',PSNR)
% fprintf('Cover image ssim = %f .\n',ssimval)
% fprintf('Cover image UACI = %f .\n',UACI)
% fprintf('Cover image entropy = %f .\n',E)
% fprintf('Cover image NC = %.4f .\n',NCC)
% fprintf('Secret image NPCR = %.4f .\n',NPCR)
%% For attacked image salt & pepper noise

end