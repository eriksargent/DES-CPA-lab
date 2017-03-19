%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% READ ME:
% When running this script make sure that
% the directory 'goodTraces' is not included
% on the path or else it will run sooooooooo
% slow, actually won't even work...
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
totalItems = 81088;
folderName = 'secmatv1_2006_04_0809/';

files = dir(strcat(folderName, '*.bin'))';
tolerance = 4;
 


parfor index = 1:81088
    file = files(index);
    filename = strcat(folderName, file.name);
    
    first = strsplit(file.name, '_k=');
    second = strsplit(char(first(2)), '_m=');
    third = strsplit(char(second(2)),'_c=');
    %disp(third(1));
    
    plainText = char(third(1));
    numZeros = 0;
    
    for i=1:length(plainText)
        if (plainText(i) == '0')
            numZeros = numZeros+1;
        end
    end
    
    if(numZeros>=tolerance)
%         disp(plainText);
        copyfile(filename,'goodTraces/');
    end
end
