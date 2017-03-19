function bin = hex2bi(str)    
bin = '';
for i=1:length(str)
        h = str(i);
        switch h
            case {'0'}
                b = ' 0 0 0 0 ';
            case {'1'}
                b = ' 0 0 0 1 ';
            case {'2'}
                b = ' 0 0 1 0 ';
            case {'3'}
                b = ' 0 0 1 1 ';
            case {'4'}
                b = ' 0 1 0 0 ';
            case {'5'}
                b = ' 0 1 0 1 ';
            case {'6'}
                b = ' 0 1 1 0 ';
            case {'7'}
                b = ' 0 1 1 1 ';
            case {'8'}
                b = ' 1 0 0 0 ';
            case {'9'}
                b = ' 1 0 0 1 ';
            case {'A','a'}
                b = ' 1 0 1 0 ';
            case {'B','b'}
                b = ' 1 0 1 1 ';
            case {'C','c'}
                b = ' 1 1 0 0 ';
            case {'D','d'}
                b = ' 1 1 0 1 ';
            case {'E','e'}
                b = ' 1 1 1 0 ';
            case {'F','f'}
                b = ' 1 1 1 1 ';
        end
        bin = strcat(bin, b);
end
    
bin = str2num(bin);