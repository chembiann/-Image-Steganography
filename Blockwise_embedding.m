function [embimg_1]=Blockwise_embedding(m,watermark)

%% Blockwise embedding
x={}; % empty cell which will consist all blocks

k=1; dr=0; dc=0;
% dr is to address 1:8 row every time for new block in x
% dc is to address 1:8 column every time for new block in x
% k is to change the no. of cell

%%%%%%%%%%%%%%%%% To divide image in to 4096---8X8 blocks %%%%%%%%%%%%%%%%%%
for ii=1:8:length(m) % To address row -- 8X8 blocks of image
    for jj=1:8:length(m) % To address columns -- 8X8 blocks of image
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% To insert watermark in to  blocks %%%%%
i=[]; j=[]; w=1; wmrk=watermark; welem=numel(wmrk); % welem - no. of elements
for k=1:65536
    kx=(x{k}); % Extracting block into kx for processing
    for i=1:8 % To address row of block
        for j=1:8 % To adress column of block
            if (i==8) && (j==8) && (w<=welem) % Eligiblity condition to insert watremark
                % i=1 and j=1 - means embedding element in first bit of every block
                if wmrk(w)==0
                    kx(i,j)=kx(i,j)+7;
                elseif wmrk(w)==1
                    kx(i,j)=kx(i,j)-7;
                end
            end
        end
    end
    w=w+1;
    x{k}=kx; kx=[]; % Watermark value will be replaced in block
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%% To recombine cells in to image %%%%%%%%%
i=[]; j=[]; data=[]; count=0;
embimg1={}; % Changing complete row cell of 4096 into 64 row cell
for j=1:256:65536
    count=count+1;
    for i=j:(j+255)
        data=[data,x{i}];
    end
    embimg1{count}=data;
    data=[];
end

    % Change 64 row cell in to particular columns to form image
    i=[]; j=[]; data=[];
    embimg_1=[];  % final watermark image of LWT
    for i=1:256
        embimg_1=[embimg_1;embimg1{i}];
    end
    embimg_1=(uint8(blkproc(embimg_1,[8 8],@idct2)));
end
