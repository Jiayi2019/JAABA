%% import data file
function data=import_data(directory,pattern)
    %% extract data from txt files
    Folder= dir(directory);
    for i=1:numel(Folder)
        if contains(Folder(i).name,pattern)
            filename=strcat(directory,'\',Folder(i).name);
            break
        end
    end

    %% Read columns of data as strings:
    % For more information, see the TEXTSCAN documentation.
    if contains(directory,'crawl')
        formatSpec = '%s%s%s%s%s%s%s%s%s%s%s\n';
    elseif contains(directory,'roll')
        formatSpec = '%s%s%s%s%s%s%s%s%s\n';
    elseif contains(directory,'hunch')
        formatSpec = '%s%s%s%s%s%s%s%s%s\n';
    elseif contains(directory,'turn')
        formatSpec = '%s%s%s%s%s%s%s%s%s\n';
    end
    %% Convert all the numbers
    data=convert_str2num(filename,formatSpec);
end