function [rgb3, rgb2, keys] = iFractal_Encryption(I)
    rgb = I;
    sizeM = size(rgb);
    nn = sizeM(1);
    mm = sizeM(2);

    % Transpose the Fractals
    rgb1 = permute(rgb, [2, 1, 3]); % Transpose the image correctly
    rgb2 = rgb1;

    % Prepare the L shapes with enhanced pattern
    medium = mean(rgb2(:));
    ceilin = round(sqrt((255 - medium) * medium));

    % Generate more secure and dynamic keys
    key1 = randi([5, min(nn, mm) / 2]); % Dynamic key size based on image dimensions
    key2 = 2 * key1;
    key3 = randi([1, 100]); % Additional key for added security

    % Store the keys for decryption
    keys = [key1, key2, key3];

    % Process RGB in a loop with enhanced pattern
    for ic = 1:size(rgb, 3)
        for ii = 1:nn
            for jj = 1:mm
                if mod(ii + key3, key2 * ic) < key1 * ic
                    rgb2(ii, jj, ic) = mod(jj + key3, ceilin);
                    if mod(jj + key3, key2 * ic) < key1 * ic
                        rgb2(ii, jj, ic) = mod(ii + key3, ceilin);
                    else
                        rgb2(ii, jj, ic) = mod(ceilin - ii + key3, ceilin);
                    end
                else
                    rgb2(ii, jj, ic) = mod(ceilin - jj + key3, ceilin);
                end
            end
        end
    end

    % Encrypt the image
    rgb3 = bitxor(rgb1, rgb2);
end
