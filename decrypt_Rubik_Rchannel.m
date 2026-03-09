function decrypted_image = decrypt_Rubik_Rchannel(encrypted_image,opts)
    [M, N] = size(encrypted_image); % Size of the image
KR=opts.KR;KC=opts.KC;Itera_max=opts.Itera_max;
   
% Decryption process
    Itera = 0;
    while Itera < Itera_max
        Itera = Itera + 1;

        % Step 7: Bitwise XOR operation with KR vector
        decrypted_image = bitxor(encrypted_image, repmat(KR', 1, N));

        % Step 6: Bitwise XOR operation with KC vector
        decrypted_image = bitxor(decrypted_image, repmat(KC, M, 1));

        % Step 5: Reverse the column circular shift
        for j = 1:N
            beta_j = sum(decrypted_image(:, j));
            M_beta_j = mod(beta_j, 2);
            if M_beta_j == 0
                decrypted_image(:, j) = circshift(decrypted_image(:, j), -KC(j)); % Down circular shift
            else
                decrypted_image(:, j) = circshift(decrypted_image(:, j), KC(j)); % Up circular shift
            end
        end

        % Step 4: Reverse the row circular shift
        for i = 1:M
            alpha_i = sum(decrypted_image(i, :));
            M_alpha_i = mod(alpha_i, 2);
            if M_alpha_i == 0
                decrypted_image(i, :) = circshift(decrypted_image(i, :), -KC(i)); % Right circular shift
            else
                decrypted_image(i, :) = circshift(decrypted_image(i, :), KC(i)); % Left circular shift
            end
        end
    end

    % Decrypted image
    decrypted_image = uint8(decrypted_image); % Convert back to uint8
end
