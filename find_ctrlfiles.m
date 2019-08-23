function [stamp_index,ctrlcrawl,ctrlroll,ctrlturn,ctrlhunch]=find_ctrlfiles(ctrl_date,driver,effector,tracker,protocol,value)
if contains(protocol,'mMAITC')
    Aind=strfind(protocol,'mMAITC');
    sind=strfind(protocol,'_');
    minlim=max(sind(sind<Aind));
    genotype=strcat(driver,'@',effector,'@',tracker,'@',protocol(1:minlim),protocol(strfind(protocol,'mMAITC')+7:end));
elseif contains(protocol,'LED1d')
    genotype=strcat(driver,'@',effector,'@',tracker,'@',protocol(1:strfind(protocol,'_LED1d')),protocol(strfind(protocol,'LED1d')+6:end));
elseif contains(protocol,'LED2d')
    genotype=strcat(driver,'@',effector,'@',tracker,'@',protocol(1:strfind(protocol,'_LED2d')),protocol(strfind(protocol,'LED2d')+6:end));
elseif contains(protocol,'ml')
    genotype=strcat(driver,'@',effector,'@',tracker,'@',protocol(1:strfind(protocol,'ml')-3),'10',protocol(strfind(protocol,'ml'):end));
elseif strcmp(driver,'attp2')&&strcmp(effector,'UAS_Chrimson_attp18_69F06')
    genotype=strcat('attp2@UAS_Chrimson_attp18_69F06@t93@r_LED10_45s2x30s30s#n#n#n');
else
    genotype=ctrlname(driver,effector);
genotype=strcat(genotype,'@',tracker,'@',protocol);
end
%%
file=strcat('E:\back_up\mfile\original_behavior\',genotype,'@100.mat');

if ~exist(file,'file')
    disp('processing control file');
    process_behavior_file(strcat(genotype,'@100'),value);
else
    fileinfo=dir(file);
    [Y,M,D,~,~,~]=datevec(fileinfo.date);
    file_date=10000*Y+100*M+D;
    if file_date<max(ctrl_date)
        process_behavior_file(strcat(genotype,'@100'),value);
    end
end
 disp('loading control file');
    load(file);
    if strcmp(driver,'attp2')&&strcmp(effector,'UAS_Chrimson_attp18_69F06')
        ctrlroll=rolldata;
        ctrlturn=turndata;
        ctrlhunch=hunchdata;
        ctrlcrawl=crawldata;
        return
    end
 if ischar(crawldata(1).time_stamp)
     disp('control file correctly loaded');
    %% 
    area=import_area('E:\back_up\area',genotype);
    %%
    ctrlcrawl=search_date(crawldata,ctrl_date);
    if ~isempty(ctrlcrawl)
        stamp=arrayfun(@(x) ctrlcrawl(x).('date'), 1:numel(ctrlcrawl));
    end
    if  isempty(ctrlcrawl) || length(unique(stamp))<2
        ctrl_date=[(min(ctrl_date)-5:max(ctrl_date)+5)'];
        clear ctrlcrawl;
        ctrlcrawl=search_date(crawldata,ctrl_date);
    end
    %%
    ctrlroll=search_date(rolldata,ctrl_date);
    if exist('turndata','var')
        ctrlturn=search_date(turndata,ctrl_date);
    end
    if exist('hunchdata','var')
        ctrlhunch=search_date(hunchdata,ctrl_date);
    end
    if ~exist('ctrlcrawl','var')|| isempty(ctrlcrawl)
        ctrlcrawl=crawldata;
        ctrlroll=rolldata;
         if ~exist('ctrlturn','var')||isempty(ctrlturn)
            ctrlturn=turndata;
            ctrlhunch=hunchdata;
         end
    end
    %% process crawl file
       [ctrlcrawl,stamp_index,~]=process_crawl(ctrlcrawl,area);
    %% process roll file
       ctrlroll=process_events(ctrlroll,ctrlcrawl);
    %%
     if exist('turndata','var')
        ctrlturn=process_events(ctrlturn,ctrlcrawl);;
     end
    %%
    if exist('hunchdata','var')
        ctrlhunch=process_events(ctrlhunch,ctrlcrawl);;
    end
else
        stamp_index=[];
        ctrlroll=[];
        ctrlturn=[];
        ctrlhunch=[];
        ctrlcrawl=[];
        disp('no control data loaded');
 end
if value==2 || (value==0&&~exist('ctrlturn','var'))
        ctrlturn=[];
        ctrlhunch=[];
end
end
function ctrl_data=search_date(data,ctrl_date)
 j=1;
    for i=1:numel(data)
        if find(ctrl_date==data(i).date)
             ctrl_data(j)=data(i);
            j=j+1;
        end
    end
    if ~exist('ctrl_data','var')
        ctrl_data=[];
    end
    
end