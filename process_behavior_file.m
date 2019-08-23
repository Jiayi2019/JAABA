function process_behavior_file(genotype,value)
switch value
    case 1
        rolldata=[];
        rolldata=import_data('E:\JAABA_analysis',genotype);
    case 2
        %% read the crawl stats file
        crawldata=[];
        crawldata=import_data( 'E:\back_up\crawling',genotype);
        %% read the roll stats file
        rolldata=[];
        rolldata=import_data('E:\back_up\rolling',genotype);
        %% read and compile area file
        area={};
        area=import_area('E:\back_up\area',genotype);
        %% process crawl file
        [crawldata,stamp_index,exp_date]=process_crawl(crawldata,area);
        %% process roll file
        rolldata=process_events(rolldata,crawldata);
     
        %% save .mat files
        FileName=strcat('E:\back_up\mfile\original_behavior\',genotype,'.mat');
        save(FileName,'crawldata','rolldata','stamp_index','exp_date','FileName');
        if ~isempty(area)
            FileName=strcat('E:\back_up\area compile\',genotype,'.mat');
            save(FileName,'area','FileName');
        end
    case 4
        %% read the crawl stats file
        crawldata=[];
        crawldata=import_data('E:\back_up\crawling',genotype);
        %% read the roll stats file
        rolldata=[];
        rolldata=import_data('E:\back_up\rolling',genotype);
        %% read the hunch stats file
        hunchdata=[];
        hunchdata=import_data('E:\back_up\hunching',genotype);
        %% read the turn stats file
        turndata=[];
        turndata=import_data('E:\back_up\turning',genotype);
        %% read and compile area file
        area={};
        area=import_area('E:\back_up\area',genotype);
        %% process crawl file
        [crawldata,stamp_index,exp_date]=process_crawl(crawldata,area);
        %% process roll file
        rolldata=process_events(rolldata,crawldata);
        %% process hunch file
        hunchdata=process_events(hunchdata,crawldata);        
        %% process turn file
        turndata=process_events(turndata,crawldata);
        %% save .mat files
        FileName=strcat('E:\back_up\mfile\original_behavior\',genotype,'.mat');
        save(FileName,'crawldata','rolldata','hunchdata','turndata','exp_date','stamp_index','FileName');
        FileName=strcat('E:\back_up\area compile\',genotype,'.mat');
        save(FileName,'area','FileName');
    case 5
        %% read the crawl stats file
        crawldata=[];
        crawldata=import_data('E:\back_up\crawling\undergrad',genotype);
        %% read the roll stats file
        rolldata=[];
        rolldata=import_data('E:\back_up\rolling\undergrad',genotype);
        %% read the hunch stats file
        hunchdata=[];
        hunchdata=import_data('E:\back_up\hunching\undergrad',genotype);
        %% read the turn stats file
        turndata=[];
        turndata=import_data('E:\back_up\turning\undergrad',genotype);
        %% read and compile area file
        area={};
        area=import_area('E:\back_up\area',genotype);
        %% process crawl file
        [crawldata,stamp_index,exp_date]=process_crawl(crawldata,area);
        %% process roll file
        rolldata=process_events(rolldata,crawldata);
        %% process hunch file
        hunchdata=process_events(hunchdata,crawldata);        
        %% process turn file
        turndata=process_events(turndata,crawldata);
%         %% save .mat files
%         FileName=strcat('E:\back_up\mfile\original_behavior\',genotype,'.mat');
%         save(FileName,'crawldata','rolldata','hunchdata','turndata','exp_date','stamp_index','FileName');
%         FileName=strcat('E:\back_up\area compile\',genotype,'.mat');
%         save(FileName,'area','FileName');
end   
end