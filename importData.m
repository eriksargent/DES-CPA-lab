function [time, voltages, messages, keys, ciphers] = importData(folderName, maxItems)

files = dir(strcat(folderName, '*.bin'))';
voltages = [];

time = importAgilentBin(strcat(folderName, files(1).name));

messages = [];
keys = [];
ciphers = [];

parfor index = 1:maxItems
    file = files(index);
    filename = strcat(folderName, file.name);
    
    [~, voltage] = importAgilentBin(filename);
    voltages = [voltages voltage];
    
    key = strsplit(file.name, '_k=');
    message = strsplit(string(key(2)), '_m=');
    key = message(1);
    message = strsplit(string(message(2)), '_c=');
    cipher = strsplit(string(message(2)), '.bin');
    message = message(1);
    messages = [messages message];
    keys = [keys key];
    ciphers = [ciphers cipher];
end