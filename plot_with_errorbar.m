function plot_with_errorbar(x,y,eb,color)
y1=y+eb;
y2=flip(y-eb);
y_total=[y1,y2];
x_total=[x,flip(x)];
x_total(isnan(y_total))=[];
y_total(isnan(y_total))=[];
plot(x,y,'Color',color);
f=fill(x_total,y_total,color);
f.FaceAlpha=0.1;
f.EdgeColor='none';
end