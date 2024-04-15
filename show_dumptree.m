%% Example
function show_dumptree(filename)


    mt = mtreeplus(strcat(filename, '.m'), '-file', '-comments');
    % mt.dumptree()
    % 
    fprintf('--------------------------------\n')
    
    %filename = strcat('preprocessed_',filename);
    %mt = mtreeplus(strcat(filename, '.m'), '-file', '-comments');
    mt.dumptree()

 end