%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is the second optimization: Subkey Hysteresis.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('Running optimization 2: Subkey Hysteresis');

% Number of traces to load in
numValues = 500;
% Directory of the traces
folderName = 'secmatv1_2006_04_0809/';

% Import trace data
[time, voltages, messages, keys, ciphers] = importData(folderName, numValues);

% Load out the plantext/key/cipher to use to use when bruteforcing the last
% 8 bits
testPlaintext = hex2bi(char(messages(1)));
testKey = hex2bi(char(keys(1)));
testCipher = hex2bi(char(ciphers(1)));

hds = zeros(numValues, 64, 8);
key = zeros(1,64);
prevSubkey = zeros(8);
cnt = 0;
subkeyQueue = zeros(10, 8);

% Process each trace
for i = 1:numValues
    % Turn the plaintext into a binary vector
    mHex = hex2bi(char(messages(i)));
    % Run the first round of DES on each vector and get the hamming
    % distance results
    hds(i, :, :) = DESR1(mHex, 'ENC', key).';
    
    % Run a correlation analysis on all data so far
    % Find the combination of subkeys that matches the trace data the best
    corrs = zeros(8, 64, 11); 
    subkey = zeros(8, 1);
    for k=1:8
        corrs(k, :, :) = corr(hds(:, :, k),voltages(5739:5749, :).');
        [~,maxIndex] = max(max(corrs(k, :, :)));
        [~,subkey(k)] = max(corrs(k, :, maxIndex));
    end
    
    % Keep a rolling queue of the last 10 subkeys 
    % This is used to add hysteresis to the comparison
    subCorr = corr(subkey, subkeyQueue');
    subkeyQueue(1,:) = subkeyQueue(2,:);
    subkeyQueue(2,:) = subkeyQueue(3,:);
    subkeyQueue(3,:) = subkeyQueue(4,:);
    subkeyQueue(4,:) = subkeyQueue(5,:);
    subkeyQueue(5,:) = subkeyQueue(6,:);
    subkeyQueue(6,:) = subkeyQueue(7,:);
    subkeyQueue(7,:) = subkeyQueue(8,:);
    subkeyQueue(8,:) = subkeyQueue(9,:);
    subkeyQueue(9,:) = subkeyQueue(10,:);
    
    if i > 50
        % Reset the count when the subkey values are still changing
        % frequently. If they are holding steady, then start counting.
        % Return the result when the count reaches 100
        if sum(subCorr) > 3
            cnt = cnt + 1;

            if cnt >= 100
                disp(strcat('  Total traces used: ', num2str(i)));
                break;
            end
            
            prevSubkey = subkey;
        else 
            cnt = 0;
        end
    else
        prevSubkey = subkey;
    end
    
    subkeyQueue(10,:) = subkey;
end

% Turn the subkey into binary, and reverse the order
binary = fliplr(de2bi(subkey - 1))';
binary = binary(:)';

key64 = zeros(1,64);
key56 = ones(1,56)*3;
key56b = zeros(1,64);

% These vectors are usedd to undo the permutations from the DES round
PC1L = [57	49	41	33	25	17	9 ...
        1	58	50	42	34	26	18 ...
        10	2	59	51	43	35	27 ...
        19	11	3	60	52	44	36];
PC1R = [63	55	47	39	31	23	15 ...
        7	62	54	46	38	30	22 ... 
        14	6	61	53	45	37	29 ...
        21	13	5	28	20	12	4];
    
PC2 = [14 17	11	24	1	5	3	28 ...
         15	6	21	10	23	19	12	4 ...
         26	8	16	7	27	20	13	2 ...
         41	52	31	37	47	55	30	40 ...
         51	45	33	48	44	49	39	56 ...
         34	53	46	42	50	36	29	32];

rshift = [2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,1,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,29];

% Undo the permutations to get the original key
for i = 1:48
    key56(PC2(i)) = binary(i);
end
for i = 1:56
    key56b(rshift(i)) = key56(i);
end
for i = 1:28
    key64(PC1L(i)) = key56b(i);
    key64(PC1R(i)) = key56b(i+28);
end

% Brute force the remaining 8 bits of the key
bits = de2bi((0:128)');
for i = 1:129
    key64(6)=bits(i,1);
    key64(7)=bits(i,2);
    key64(11)=bits(i,3);
    key64(12)=bits(i,4);
    key64(43)=bits(i,5);
    key64(46)=bits(i,6);
    key64(50)=bits(i,7);
    key64(52)=bits(i,8);
    
    % Compare each generated key with the known plaintext and ciphertext
    % until they match.
    if DES(testPlaintext, 'ENC', key64) == testCipher
        disp('  Found key!!!');
        break
    end
end

% Generate the parity bits
key64(8)=mod(sum(key64(1:8)),2);
key64(16)=mod(sum(key64(9:16)),2);
key64(24)=mod(sum(key64(17:24)),2);
key64(32)=mod(sum(key64(25:32)),2);
key64(40)=mod(sum(key64(33:40)),2);
key64(48)=mod(sum(key64(41:48)),2);
key64(56)=mod(sum(key64(49:56)),2);
key64(64)=mod(sum(key64(57:64)),2);

% Output the final key
finalKey = sprintf('%d', key64);
hex = bin2hex(finalKey);
disp('  Found key: ');
disp(hex);
disp('  Given key: ');
disp(keys(1));