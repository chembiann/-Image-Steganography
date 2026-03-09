function [encrypted_image,KR,KC,Itera_max] = Rubik_R_channel(Io)
KR=randi(2,[1,size(Io,1)]);KC=randi(2,[1,size(Io,2)]);Itera_max=1;

    [M, N] = size(Io); % Size of the image
    % Encryption process
    Itera = 0;
    while Itera < Itera_max
        Itera = Itera + 1;

        % Step 4: For all rows i of image Io
        for i = 1:M
            % Determine the total of every element in the row i
            alpha_i = sum(Io(i, :));

            % Determine modulo 2 of alpha_i
            M_alpha_i = mod(alpha_i, 2);

            % Apply circular shift based on M_alpha_i and KC(i)
            if M_alpha_i == 0
                Io(i, :) = circshift(Io(i, :), KC(i)); % Right circular shift
            else
                Io(i, :) = circshift(Io(i, :), -KC(i)); % Left circular shift
            end
        end

        % Step 5: For every column j of image Io
        for j = 1:N
            % Determine the total of every element in the column j
            beta_j = sum(Io(:, j));

            % Determine modulo 2 of beta_j
            M_beta_j = mod(beta_j, 2);

            % Apply circular shift based on M_beta_j and KR(j)
            if M_beta_j == 0
                Io(:, j) = circshift(Io(:, j), KC(j)); % Down circular shift
            else
                Io(:, j) = circshift(Io(:, j), -KC(j)); % Up circular shift
            end
        end

        % Step 6: Bitwise XOR operation with KC vector
        Io = bitxor(Io, repmat(KC, M, 1));

        % Step 7: Bitwise XOR operation with KR vector
        Io = bitxor(Io, repmat(KR', 1, N));
    end

    % Encrypted image
    encrypted_image = Io;
end
