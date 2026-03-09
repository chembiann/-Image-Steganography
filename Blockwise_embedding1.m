function [embimg_1] = Blockwise_embedding1(m, watermark)
    % Blockwise embedding
    x = {}; % Empty cell which will consist all blocks
    
    k = 1; dr = 0; dc = 0;
    
    % To divide image into 8x8 blocks
    for ii = 1:8:length(m)
        for jj = 1:8:length(m)
            for i = ii:(ii + 7)
                dr = dr + 1;
                for j = jj:(jj + 7)
                    dc = dc + 1;
                    z(dr, dc) = m(i, j);
                end
                dc = 0;
            end
            x{k} = z;
            k = k + 1;
            z = [];
            dr = 0;
        end
    end

    % Insert watermark into blocks
    w = 1; welem = numel(watermark);
    for k = 1:numel(x)
        kx = x{k};
        for i = 1:8
            for j = 1:8
                if (i == 8) && (j == 8) && (w <= welem)
                    if watermark(w) == 0
                        kx(i, j) = kx(i, j) + 7;
                    elseif watermark(w) == 1
                        kx(i, j) = kx(i, j) - 7;
                    end
                    w = w + 1;
                end
            end
        end
        x{k} = kx;
    end

    % Recombine blocks into image
    embimg1 = [];
    for i = 1:8:length(m)
        row_blocks = [];
        for j = 1:8:length(m)
            row_blocks = [row_blocks, x{((i - 1) / 8) * (length(m) / 8) + (j - 1) / 8 + 1}];
        end
        embimg1 = [embimg1; row_blocks];
    end
    
    embimg_1 = uint8(blkproc(embimg1, [8 8], @idct2));
end
