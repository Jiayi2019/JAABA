% Rolling and crawling combination
function behavior_screen_JAABA(genotype,value)
%close
%% read name for the genotype
[driver,effector,tracker,protocol,times]=read_name(genotype);
waiting=times.waiting;
circles=times.circles;
stimdur=times.stimdur;
stimint=times.stimint;
stimspec=stimdur+stimint;
marker.driver=driver;
marker.effector=effector;
marker.tracker=tracker;
marker.protocol=protocol;
marker.times=times;

%%
if value~=0
    process_behavior_file(genotype,value);   
end 
crawldata=[];
rolldata=[];
turndata=[];
hunchdata=[];
load(strcat('E:\back_up\mfile\original_behavior\',genotype,'_JAABA.mat'));

%% load the corresponding control data
[ctrl_stamp_index,ctrlcrawl,ctrlroll,ctrlturn,ctrlhunch]=find_ctrlfiles(exp_date,driver,effector,tracker,protocol,value);%modify
%%
if contains(protocol,'AITC')
    genotype=strcat(genotype,'@noAITC');
end
name=strcat('E:\back_up\hit\',genotype);
    %,'@impTNT'
    %,'@KZ_ctrl'
name(name=='.')=[];
%% Create the time axis
    eventnumber=crawldata(end).event;
    ctrleventnumber=ctrlcrawl(end).event;
    timespec=waiting+circles*stimspec;
    timeres=0.2;
    timeframe =floor(timespec/timeres)+1;
    time=timeres*(0:(timeframe-1));

%% count the tracked animal number and select roller and non-roller
[RollerEvent,NRollerEvent,TrkedEvent]=count_tracked_animals(rolldata,eventnumber,timeframe,timeres);
trkedevent=sum(TrkedEvent(:,1:timeframe));
%%
[CtrlRollerEvent,CtrlNRollerEvent,CtrlTrkedEvent]=count_tracked_animals(ctrlroll,ctrleventnumber,timeframe,timeres);
ctrltrkedevent=sum(CtrlTrkedEvent(:,1:timeframe));

%% Stack crawl events
[events,fevents,bevents,starttime,fstarttime,bstarttime,base_crawl_ampl]=...
    stack_crawl(crawldata,timeframe,timeres,waiting);
%%
[ctrlevents,ctrlfevents,ctrlbevents,ctrlstarttime,ctrlfstarttime,ctrlbstarttime,...
    ctrl_base_crawl_ampl]=stack_crawl(ctrlcrawl,timeframe,timeres,waiting);

%% Stack roll events
[revents,rstarttime]=stack_events(rolldata,timeframe,timeres);
%%
[ctrlrevents,ctrlrstarttime]=stack_events(ctrlroll,timeframe,timeres);
%% Calculate the probabilities
  sumevents=sum(events);
% sumbaseevents=sum(bevents);
 sumfastevents=sum(fevents);
 sumrevents=sum(revents);
%  sumstarttime=sum(starttime);
%  sumfstarttime=sum(fstarttime);
%  sumbstarttime=sum(bstarttime);
%  sumrstarttime=sum(rstarttime);
 
 prob=sumevents./trkedevent;
% bprob=sumbaseevents./trkedevent;
 fprob=sumfastevents./trkedevent;
 rprob=sumrevents./trkedevent;
%  start=sumstarttime./trkedevent;
%  fstart=sumfstarttime./trkedevent;
%  bstart=sumbstarttime./trkedevent;
%  rstart=sumrstarttime./trkedevent;
 %%
 ctrlsumevents=sum(ctrlevents);
%  ctrlsumbaseevents=sum(ctrlbevents);
 ctrlsumfastevents=sum(ctrlfevents);
 ctrlsumrevents=sum(ctrlrevents);
%  ctrlsumstarttime=sum(ctrlstarttime);
%  ctrlsumfstarttime=sum(ctrlfstarttime);
%  ctrlsumbstarttime=sum(ctrlbstarttime);
%  ctrlsumrstarttime=sum(ctrlrstarttime);
 
 ctrlprob=ctrlsumevents./ctrltrkedevent;
%  ctrlbprob=ctrlsumbaseevents./ctrltrkedevent;
 ctrlfprob=ctrlsumfastevents./ctrltrkedevent;
 ctrlrprob=ctrlsumrevents./ctrltrkedevent;
%  ctrlstart=ctrlsumstarttime./ctrltrkedevent;
%  ctrlfstart=ctrlsumfstarttime./ctrltrkedevent;
%  ctrlbstart=ctrlsumbstarttime./ctrltrkedevent;
%  ctrlrstart=ctrlsumrstarttime./ctrltrkedevent;
 %% calculate the average ampl
crawlampl=bin_ampl(crawldata);
ctrlcrawlampl=bin_ampl(ctrlcrawl);
AverageCFilename=strcat('E:\back_up\mfile\csv_files\crawl_in_15s_bins\',genotype,'.xlsx');
if strcmp(driver,'attp2')
    ctrlname='ctrl';
    expname=protocol;
else
    ctrlname='attp2';
    expname=driver;
end
write_stamp_file(crawlampl,ctrlcrawlampl,expname,ctrlname,AverageCFilename);
%% calculate the probability per stamp
[CProInStamp,RProInStamp,FProInStamp]=stamp_analysis(times,TrkedEvent,fevents,revents,events,stamp_index,timeres);
[CtrlCProInStamp,CtrlRProInStamp,CtrlFProInStamp]=stamp_analysis(times,CtrlTrkedEvent,ctrlfevents,...
    ctrlrevents,ctrlevents,ctrl_stamp_index,timeres);

%% calculating crawling amplitude in time series
average_ampl=time_series_calculation(crawldata,'crawldata','ampl',timeres,timespec);
ctrl_average_ampl=time_series_calculation(ctrlcrawl,'ctrlcrawl','ampl',timeres,timespec);
%% 
    CFilename=strcat('E:\back_up\mfile\csv_files\crawl_in_stamp\',genotype,'.xlsx');
    write_stamp_file(CProInStamp,CtrlCProInStamp,expname,ctrlname,CFilename);
    RFilename=strcat('E:\back_up\mfile\csv_files\roll_in_stamp\',genotype,'.xlsx');
    write_stamp_file(RProInStamp,CtrlRProInStamp,expname,ctrlname,RFilename);
    FFilename=strcat('E:\back_up\mfile\csv_files\fast_crawl_in_stamp\',genotype,'.xlsx');
    write_stamp_file(FProInStamp,CtrlFProInStamp,expname,ctrlname,FFilename);

%% cumulative for rolling duration
  RollDur=parameter_extraction(rolldata,'rolldata','rdur',waiting,waiting+stimdur);
  [TimeForRollDur,CumRollDur]=cumulative_calculation(RollDur);
  CtrlRollDur=parameter_extraction(ctrlroll,'ctrlroll','rdur',waiting,waiting+stimdur);
  [CtrlTimeForRollDur,CtrlCumRollDur]=cumulative_calculation(CtrlRollDur);
  %%
   CrawlStart=parameter_extraction(crawldata,'crawldata','beg',waiting,waiting+stimdur);
  [TimeForCrawlStart,CumCrawlStart]=cumulative_calculation(CrawlStart(:,1));
  CtrlCrawlStart=parameter_extraction(ctrlcrawl,'ctrlcrawl','beg',waiting,waiting+stimdur);
  [CtrlTimeForCrawlStart,CtrlCumCrawlStart]=cumulative_calculation(CtrlCrawlStart(:,1));
%% cumulative for crawling duration
  CrawlDur=parameter_extraction(crawldata,'crawldata','dur',waiting,waiting+stimdur);
  [TimeForCrawlDur,CumCrawlDur]=cumulative_calculation(CrawlDur);
  CtrlCrawlDur=parameter_extraction(ctrlcrawl,'ctrlcrawl','dur',waiting,waiting+stimdur);
  [CtrlTimeForCrawlDur,CtrlCumCrawlDur]=cumulative_calculation(CtrlCrawlDur);
%% fast crawling for individuals
  findex=fast_crawling_def(crawldata,times);
  ctrlfindex=fast_crawling_def(ctrlcrawl,times);
  FastFilename=strcat('E:\back_up\mfile\csv_files\fast_crawl\',genotype,'.xlsx');
    write_stamp_file(findex(:,2),ctrlfindex(:,2),expname,ctrlname,FastFilename);
%% Plot crawling start point
fig1=figure;

%% Plot ethogram of crawling
subplot(3,3,[1 3]);
x=[];
y=[];
pa=parula(64);
row=numel(crawldata);
eventnumber=crawldata(end).event;
for i=1:row
    if isnan(crawldata(i).ampl)==0
        color=floor((crawldata(i).ampl/base_crawl_ampl-0.5)*32);
        if color>64
            color=64;
        end
        if color<1
            color=1;
        end
        line([crawldata(i).beg, crawldata(i).beg + crawldata(i).dur],[crawldata(i).event+0.1,crawldata(i).event+0.1],'Color',pa(color,1:3));
        hold on
     end
end
caxis([0.5 2]);
c = colorbar('Limits',[0 2]);
c.Label.String = 'normalized crawling speed';
xlabel('time (s)');
ylabel('animal number#');
hold on
l=line([waiting, waiting],[0,eventnumber],'Color',[0.5 0.5 0.5]);
l.LineStyle='--';
hold on
l=line([waiting+stimdur, waiting+stimdur],[0,eventnumber],'Color',[0.5 0.5 0.5]);
l.LineStyle='--';
hold on
l=line([waiting+stimdur+stimint, waiting+stimdur+stimint],[0,eventnumber],'Color',[0.5 0.5 0.5]);
l.LineStyle='--';
hold on
l=line([waiting+2*stimdur+stimint, waiting+2*stimdur+stimint],[0,eventnumber],'Color',[0.5 0.5 0.5]);
l.LineStyle='--';
hold on
ylim([0 eventnumber]);
xlim([waiting-15 timespec]);
%% Plot ethogram of rolling
rrow=numel(rolldata);
for i=1:rrow
    if isnan(rolldata(i).rampl)==0
        line([rolldata(i).rbeg, rolldata(i).rbeg + rolldata(i).rdur],[rolldata(i).event,rolldata(i).event],'Color',[1 0 0]);
        hold on
    end
end

    %% Plot accumulative duration graph
    subplot(3,3,[4 5]);
fill_stim(times,circles,0,100);
line_plot(time,100*fprob,100*ctrlfprob,[0 0 1],[0.7 0.7 1]);
line_plot(time,100*prob,100*ctrlprob,[0 1 0],[0.5 1 0.5]);
line_plot(time,100*rprob,100*ctrlrprob,[1 0 0],[1 0.7 0.7]);
 axes2=gca;
 xlim(axes2,[waiting-15 timespec]);
 ylim(axes2,[0 100]);
 ylabel('percentage');
 xlabel('time (s)');
box off;

%% plot amplitude
subplot(3,3,[7 8]);
fill_stim(times,circles,0.5,3)
plot_with_std(time,average_ampl/base_crawl_ampl,'b');
hold on
plot_with_std(time,ctrl_average_ampl/ctrl_base_crawl_ampl,'k');
%line_plot(time,average_ampl/base_crawl_ampl,ctrl_average_ampl/ctrl_base_crawl_ampl,[0 0 1],[0.7 0.7 1]);%/ctrl_base_crawl_ampl
hold on
line([waiting-15,timespec],[1,1],'LineStyle','--','Color',[0.5 0.5 0.5]);
axes2=gca;
xlim(axes2,[waiting-15 timespec]);
ylim(axes2,[0.5 2]);
ylabel('normalized crawling speed');
xlabel('time (s)')
box off
  %% plot cumulative for rolling duration
 subplot(3,3,9);
plot([0,TimeForRollDur],[0,CumRollDur],'r');
hold on
plot([0,CtrlTimeForRollDur],[0,CtrlCumRollDur],'k');
ylim([0 1]);
xlim([0 10]);
 ylabel('probability');
 xlabel('rolling duration (s)')
box off
  %% plot cumulative for crawlling duration
  subplot(3,3,6);
plot([0,TimeForCrawlDur],[0,CumCrawlDur],'b');
hold on
plot([0,CtrlTimeForCrawlDur],[0,CtrlCumCrawlDur],'k');
ylim([0 1]);
 ylabel('probability');
 xlabel('crawling duration (s)')
box off

%%
 print(fig1,name,'-painters','-dpdf','-fillpage');
%savefig(fig1,strcat(name,'.fig'));
close 
%% behavior patterns in stamp

figure3=figure(3)
subplot(4,1,1)
hold on
%%
fastc_prob=nan(1,timeframe);
fastc_u=nan(1,timeframe);
for i=1:timeframe
    [fastc_prob(i),fastc_u(i)]=bernuli(TrkedEvent(:,i),fevents(:,i));
end
fastc_CI=2*fastc_u;
%%
ctrl_fastc_prob=nan(1,timeframe);
ctrl_fastc_u=nan(1,timeframe);
for i=1:timeframe
    [ctrl_fastc_prob(i),ctrl_fastc_u(i)]=bernuli(CtrlTrkedEvent(:,i),ctrlfevents(:,i));
end
ctrl_fastc_CI=2*ctrl_fastc_u;
%%
for i=1:circles
f=fill([waiting+(i-1)*(stimdur+stimint),waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)],[0,0,100,100],'k');
f.FaceAlpha=0.1;
f.EdgeColor='none';
end
plot_with_errorbar(time,100*fastc_prob,100*fastc_CI,[0 0 1]);
plot_with_errorbar(time,100*ctrl_fastc_prob,100*ctrl_fastc_CI,[0 0 0]);
xlim([waiting-15 timespec]);
ylim([0,100]);
ylabel('Fast crawling (%)');
xlabel('time (s)')
box off
hold off
%%
subplot(4,1,2)
hold on
%%
roll_prob=nan(1,timeframe);
roll_u=nan(1,timeframe);
for i=1:timeframe
    [roll_prob(i),roll_u(i)]=bernuli(TrkedEvent(:,i),revents(:,i));
end
roll_CI=2*roll_u;
%%
ctrl_roll_prob=nan(1,timeframe);
ctrl_roll_u=nan(1,timeframe);
for i=1:timeframe
    [ctrl_roll_prob(i),ctrl_roll_u(i)]=bernuli(CtrlTrkedEvent(:,i),ctrlrevents(:,i));
end
ctrl_roll_CI=2*ctrl_roll_u;
%%
for i=1:circles
f=fill([waiting+(i-1)*(stimdur+stimint),waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)],[0,0,100,100],'k');
f.FaceAlpha=0.1;
f.EdgeColor='none';
end
plot_with_errorbar(time,100*roll_prob,100*roll_CI,[1 0 0])
plot_with_errorbar(time,100*ctrl_roll_prob,100*ctrl_roll_CI,[0 0 0])
xlim([waiting-15 timespec]);
ylim([0,100]);
ylabel('Rolling (%)');
xlabel('time (s)')
box off
hold off
%%
subplot(4,1,3)
if ~isempty(turndata)
    %%
    [tevents,~]=stack_events(turndata,timeframe,timeres);
    [ctrltevents,~]=stack_events(ctrlturn,timeframe,timeres);
hold on
 for i=1:circles
f=fill([waiting+(i-1)*(stimdur+stimint),waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)],[0,0,100,100],'k');
f.FaceAlpha=0.1;
f.EdgeColor='none';
 end
 %%
turn_prob=nan(1,timeframe);
turn_u=nan(1,timeframe);
for i=1:timeframe
    [turn_prob(i),turn_u(i)]=bernuli(TrkedEvent(:,i),tevents(:,i));
end
turn_CI=2*turn_u;
%%
ctrl_turn_prob=nan(1,timeframe);
ctrl_turn_u=nan(1,timeframe);
for i=1:timeframe
    [ctrl_turn_prob(i),ctrl_turn_u(i)]=bernuli(CtrlTrkedEvent(:,i),ctrltevents(:,i));
end
ctrl_turn_CI=2*ctrl_turn_u;
plot_with_errorbar(time,100*turn_prob,100*turn_CI,[1 0 1])
plot_with_errorbar(time,100*ctrl_turn_prob,100*ctrl_turn_CI,[0 0 0])
    xlim([waiting-15 timespec]);
 ylim([0,100]);
ylabel('Turning (%)');
xlabel('time (s)')
box off
hold off
else
    tevents=[];
end
%%
subplot(4,1,4)
hold on
if ~isempty(hunchdata)
    %%
    [hevents,~]=stack_events(hunchdata,timeframe,timeres);
    [ctrlhevents,~]=stack_events(ctrlhunch,timeframe,timeres);

for i=1:circles
f=fill([waiting+(i-1)*(stimdur+stimint),waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)+stimdur,waiting+(i-1)*(stimdur+stimint)],[0,0,100,100],'k');
f.FaceAlpha=0.1;
f.EdgeColor='none';
end
%%
hunch_prob=nan(1,timeframe);
hunch_u=nan(1,timeframe);
for i=1:timeframe
    [hunch_prob(i),hunch_u(i)]=bernuli(TrkedEvent(:,i),hevents(:,i));
end
hunch_CI=2*hunch_u;
%%
ctrl_hunch_prob=nan(1,timeframe);
ctrl_hunch_u=nan(1,timeframe);
for i=1:timeframe
    [ctrl_hunch_prob(i),ctrl_hunch_u(i)]=bernuli(CtrlTrkedEvent(:,i),ctrlhevents(:,i));
end
ctrl_hunch_CI=2*ctrl_hunch_u;
%     f1=plot_with_std(time,100*hprob_in_stamp,[0.5 0.5 0.5]);
% hold on
% f2=plot_with_std(time,100*ctrl_hprob_in_stamp,'k');
plot_with_errorbar(time,100*hunch_prob,100*hunch_CI,[0.5 0.5 0.5])
plot_with_errorbar(time,100*ctrl_hunch_prob,100*ctrl_hunch_CI,[0 0 0])
    xlim([waiting-15 timespec]);
    ylim([0,100]);
    ylabel('Hunching (%)');
xlabel('time (s)')
box off
hold off
    %%
    hcount=sum(hevents(:,waiting/timeres:(waiting+stimdur)/timeres),2);
    hamount=sum(hcount>0);
    trkedcount=sum(TrkedEvent(:,waiting/timeres:(waiting+stimdur)/timeres),2);
    trkedamount=sum(trkedcount>0);
    ctrlhcount=sum(ctrlhevents(:,waiting/timeres:(waiting+stimdur)/timeres),2);
    ctrlhamount=sum(ctrlhcount>0);
    ctrltrkedcount=sum(CtrlTrkedEvent(:,waiting/timeres:(waiting+stimdur)/timeres),2);
    ctrltrkedamount=sum(ctrltrkedcount>0);
    [p,chi]=chi_square([hamount trkedamount-hamount;ctrlhamount ctrltrkedamount-ctrlhamount]);
    title(sprintf('p=%d,trkedn=%d,hunchn=%d',p,trkedamount,hamount));
else
    hevents=[];
end
print(figure3,strcat(name,'@patterns_in_stamp'),'-fillpage','-painters','-dpdf')

% savefig(figure3,strcat(name,'@patterns_in_stamp.fig'));
close

%% Plot crawling amplitude of genotype and ctrl
fig2=figure;
subplot(3,2,[1 2])
p1=scatter_plot(AverageCFilename,[0 0 0;0 0 1;0 0 0;0 0 1;0 0 0;0 0 1;0 0 0;0 0 1]);
ylabel('crawling speed (mm/s)');
xticks([1.5:2:7.5]);
xticklabels({'-15--0','0--15','15--30','30--45'});
xlabel('time (s)')
 %%
subplot(3,2,3)
p2=scatter_plot(FastFilename,[0 0 0;0 0 1]);
hold on
draw_significance([1 2],5.8,p2(1,2));
hold off
ylabel('crawling speed ratio');
 %%
subplot(3,2,4)
p3=scatter_plot(CFilename,[0 0 0;0 0 1]);
ylabel('fast crawling probability (%)');
%%
subplot(3,2,5)
p4=scatter_plot(RFilename,[0 0 0;1 0 0]);
ylabel('rolling probability (%)');
%%
subplot(3,2,6)
p5=scatter_plot(FFilename,[0 0 0;0 0 1]);
ylabel('crawling probability (%)');
print(fig2,strcat(name,'@binned_graphs'),'-fillpage','-painters','-dpdf');
%savefig(fig2,strcat(name,'@binned_graphs.fig'));
close
%% bernoulli distribution
fig4=figure;
[prob_f(1),u_f(1),obs_f(1,:)]=bernuli_percentage(CtrlTrkedEvent(:,55/timeres:65/timeres),ctrlfevents(:,55/timeres:65/timeres));
[prob_f(2),u_f(2),obs_f(2,:)]=bernuli_percentage(TrkedEvent(:,55/timeres:65/timeres),fevents(:,55/timeres:65/timeres));
[prob_r(1),u_r(1),obs_r(1,:)]=bernuli_percentage(CtrlTrkedEvent(:,45/timeres:55/timeres),ctrlrevents(:,45/timeres:55/timeres));
[prob_r(2),u_r(2),obs_r(2,:)]=bernuli_percentage(TrkedEvent(:,45/timeres:60/timeres),revents(:,45/timeres:60/timeres));
[prob_t(1),u_t(1),obs_t(1,:)]=bernuli_percentage(CtrlTrkedEvent(:,45/timeres:55/timeres),ctrltevents(:,45/timeres:55/timeres));
[prob_t(2),u_t(2),obs_t(2,:)]=bernuli_percentage(TrkedEvent(:,45/timeres:60/timeres),tevents(:,45/timeres:60/timeres));
[prob_h(1),u_h(1),obs_h(1,:)]=bernuli_percentage(CtrlTrkedEvent(:,45/timeres:55/timeres),ctrlhevents(:,45/timeres:55/timeres));
[prob_h(2),u_h(2),obs_h(2,:)]=bernuli_percentage(TrkedEvent(:,45/timeres:60/timeres),hevents(:,45/timeres:60/timeres));
%% chi square test
obs_f(:,1)=obs_f(:,1)-obs_f(:,2);
obs_r(:,1)=obs_r(:,1)-obs_r(:,2);
obs_t(:,1)=obs_t(:,1)-obs_t(:,2);
obs_h(:,1)=obs_h(:,1)-obs_h(:,2);
[p_f,~]=chi_square(obs_f);
[p_r,~]=chi_square(obs_r);
[p_t,~]=chi_square(obs_t);
[p_h,~]=chi_square(obs_h);
%%
subplot(2,2,1)
bar_with_errorbar(100*prob_f,100*u_f,[0 0 1]);
draw_significance([1 2],95,p_f);
ylim([0 100]);
ylabel('fast crawling probability (%)')
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'ctrl',driver})
hold off
subplot(2,2,2)
bar_with_errorbar(100*prob_r,100*u_r,[1 0 0]);
draw_significance([1 2],95,p_r);
ylim([0 100]);
ylabel('rolling probability (%)')
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'ctrl',driver})
hold off
subplot(2,2,3)
bar_with_errorbar(100*prob_t,100*u_t,[1 0 1])
draw_significance([1 2],95,p_t);
ylim([0 100]);
ylabel('turning probability (%)')
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'ctrl',driver})
hold off
subplot(2,2,4)
bar_with_errorbar(100*prob_h,100*u_h,[0.5 0.5 0.5])
draw_significance([1 2],95,p_h);
ylim([0 100]);
ylabel('hunching probability (%)')
xlim([0.5 2.5])
xticks([1 2])
xticklabels({'ctrl',driver})
hold off
%%
print(fig4,strcat(name,'@probability_graphs'),'-painters','-dpdf');
%savefig(fig4,strcat(name,'@probability_graphs.fig'));
close
%% save processed files
behavior.driver=driver;
behavior.effector=effector;
behavior.protocol=protocol;
behavior.times=times;
behavior.RollerEvent=RollerEvent;
behavior.NRollerEvent=NRollerEvent;
behavior.TrkedEvent=TrkedEvent;
behavior.trkedevent=trkedevent;
behavior.events=events;
behavior.fast_events=fevents;
behavior.starttime=starttime;
behavior.fstarttime=fstarttime;
behavior.base_crawl_ampl=base_crawl_ampl;
behavior.revents=revents;
behavior.rstarttime=rstarttime;
behavior.tevents=tevents;
behavior.hevents=hevents;
behavior.crawlampl=crawlampl;
behavior.CProInStamp=CProInStamp;
behavior.RProInStamp=RProInStamp;
behavior.FProInStamp=FProInStamp; 
behavior.average_ampl=average_ampl;
behavior.RollDur=RollDur;
behavior.CrawlDur=CrawlDur; 
behavior.findex=findex;
behavior.AverageCFilename=AverageCFilename;
behavior.CFilename=CFilename;
behavior.FFilename=FFilename;
behavior.RFilename=RFilename;
behavior.FastFilename=FastFilename;
behavior.prob_r=prob_r;
behavior.u_r=u_r;
behavior.prob_f=prob_f;
behavior.u_f=u_f;
behavior.prob_t=prob_t;
behavior.u_t=u_t;
behavior.prob_h=prob_h;
behavior.u_h=u_h;
save(strcat('E:\back_up\mfile\processed_behavior\',genotype,'.mat'),'behavior');
%% analysis on fast crawlers
fast_crawler=find(sum(fevents,2)>0);
fast_crawl_roller=intersect(fast_crawler,RollerEvent);
fast_crawl_nonroller=intersect(fast_crawler,NRollerEvent);
ctrl_fast_crawler=find(sum(ctrlfevents,2)>0);
ctrl_fast_crawl_roller=intersect(ctrl_fast_crawler,CtrlRollerEvent);
ctrl_fast_crawl_nonroller=intersect(ctrl_fast_crawler,CtrlNRollerEvent);
a=[length(fast_crawl_roller),length(fast_crawl_nonroller);length(ctrl_fast_crawl_roller),length(ctrl_fast_crawl_nonroller)];
b=sum(a,2);
b=[b,b];
c=a./b;
%%

rollstart=roll_start(revents,225,375)
ctrlrollstart=roll_start(ctrlrevents,225,375)
r_start(1).name='ctrl';
r_start(2).name=driver;
r_start(1).data=ctrlrollstart;
r_start(2).data=rollstart;
r_start(1).color=[0 0 0];
r_start(2).color=[1 0 0];
figure
subplot(2,1,1)
hold on
p=scatter_plot_struct(r_start,'onset of rolling (s)')
draw_significance([1 2],375,p(1,2));
yticks(225:25:375)
yticklabels({'0','5','10','15','20','25','30'})
hold off
%%
subplot(2,1,2)
fstart=roll_start(fevents,225,375)
ctrlfstart=roll_start(ctrlfevents,225,375)
f_start(1).name='ctrl';
f_start(2).name=driver;
f_start(1).data=ctrlfstart;
f_start(2).data=fstart;
f_start(1).color=[0 0 0];
f_start(2).color=[0 0 1];
hold on
p=scatter_plot_struct(f_start,'onset of fast crawling (s)')
draw_significance([1 2],375,p(1,2));
yticks(225:25:375)
yticklabels({'0','5','10','15','20','25','30'})
hold off
end