%% import data file
function data=import_data(directory,marker,pattern)
filename=find_file(directory, marker.tracker);
filename=find_file(filename, strcat(marker.driver,'@',marker.effector));
filename=find_file(filename, strcat(marker.protocol,'@100'));
filename=find_file(filename,strcat(marker.driver,'@',marker.effector,'@',marker.tracker,'@',marker.protocol,'@100',pattern));

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

function filename=find_file(directory,pattern)
    Folder= dir(directory);
    for i=1:numel(Folder)
        if strcmp(Folder(i).name,pattern)
            filename=strcat(directory,'\',Folder(i).name);
            break
        end
    end
end
