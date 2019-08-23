%% count the tracked animal number and select roller and non-roller
function [rollerEvent,nrollerEvent,trkedEvent]=count_tracked_animals(rolldata,eventnumber,timeframe,timeres)
rollerEvent=[];
nrollerEvent=[];
trkedEvent=zeros(eventnumber,timeframe);
alltime1=[1,rolldata(1).time1,rolldata(1).rampl]; 
rrow=numel(rolldata);
for i=2:rrow
    if strcmp(rolldata(i).time_stamp,rolldata(i-1).time_stamp)==1&&rolldata(i).animal==rolldata(i-1).animal
        alltime1=[alltime1;i,rolldata(i).time1,rolldata(i).rampl];
    else
        minInd=find(alltime1(:,2)==min(alltime1(:,2)));
        minInd=minInd(1);
        maxInd=find(alltime1(:,2)==max(alltime1(:,2)));
        maxInd=maxInd(1);
        staInd = floor((rolldata(alltime1(minInd,1)).time2-rolldata(alltime1(minInd,1)).tsize)/timeres)+1;
        endingInd = floor((rolldata(alltime1(maxInd,1)).time1+rolldata(alltime1(maxInd,1)).tsize)/timeres)+1;
        if ~isnan(staInd)&~isnan(endingInd)
        trkedEvent(rolldata(i-1).event,staInd:endingInd) = ones(1,endingInd-staInd+1);
        end
        % roller or non-roller?
        if sum(isnan(alltime1(:,3)))==length(alltime1(:,3))
            nrollerEvent=[nrollerEvent,rolldata(i-1).event];
        else
            rollerEvent=[rollerEvent,rolldata(i-1).event];
        end
        alltime1=[i,rolldata(i).time1,rolldata(i).rampl];
    end
end
%load data from last row
minInd=find(min(alltime1(:,2)));
minInd=minInd(1);
maxInd=find(max(alltime1(:,2)));
maxInd=maxInd(1);
staInd = floor((rolldata(alltime1(minInd,1)).time2-rolldata(alltime1(minInd,1)).tsize)/timeres)+1;
endingInd = floor((rolldata(alltime1(maxInd,1)).time1+rolldata(alltime1(maxInd,1)).tsize)/timeres)+1;
trkedEvent(rolldata(rrow).event,staInd:endingInd) = ones(1,endingInd-staInd+1);

%% roller or non-roller?
if sum(isnan(alltime1(:,3)))==length(alltime1(:,3))
	nrollerEvent=[nrollerEvent,rolldata(rrow).event];
else
    rollerEvent=[rollerEvent,rolldata(rrow).event];
end
end