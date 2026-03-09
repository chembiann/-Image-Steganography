function rgb6 = iFractal_decryption(rgb3, rgb2, keys)
    % Decrypt the image using the enhanced fractal Tromino method
    % rgb3: Encrypted image
    % rgb2: Fractal pattern used in encryption
    % keys: Keys used for encryption (key1, key2, key3)

    % Extract keys
    key1 = keys(1);
    key2 = keys(2);
    key3 = keys(3);

    % Perform XOR operation to reverse the encryption
    rgb4 = bitxor(uint8(rgb3), rgb2);
    
    % Reshape the image back to its original form
    rgb5 = permute(rgb4, [2, 1, 3]); % Correctly transpose the image
    rgb6 = rgb5;
    
    % Display the decrypted image (optional)
    % figure, imshow(rgb6);
    % title('The decrypted image');
end
