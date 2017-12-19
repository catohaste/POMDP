function PlotTrials(input,output)

% changing y-axis values
output.action = (1 + output.action) ./ 2;

plotLen = 2000;
plotLenVec = cat(1,ones(plotLen,1),zeros(length(input.stimTrials),1));

action = output.action(plotLenVec==1,1);

smoothAction = smooth(action,7);


blockLeft = zeros(plotLen,1);
blockLeft(strcmp(input.extraRewardTrials,'left')) = -0.03;
blockLeft(~strcmp(input.extraRewardTrials,'left')) = NaN;

blockRight = zeros(plotLen,1);
blockRight(strcmp(input.extraRewardTrials,'right')) = 1.03;
blockRight(~strcmp(input.extraRewardTrials,'right')) = NaN;

blockNone = zeros(plotLen,1);
blockNone(strcmp(input.extraRewardTrials,'none')) = 0.5;
blockNone(~strcmp(input.extraRewardTrials,'none')) = NaN;


fig = figure('Position', [100, 100, 1200, 350]);
ax = axes(fig,'position',[0.05,0.14,0.93,0.86],'fontsize',16); hold on

plot(ax,blockLeft,'marker','o','MarkerEdgeColor','b','markerfacecolor',...
   'b','markersize',2,'linestyle','none');

plot(ax,blockRight,'marker','o','MarkerEdgeColor','r','markerfacecolor',...
   'r','markersize',2,'linestyle','none');

plot(ax,blockNone,'marker','o','MarkerEdgeColor','k','markerfacecolor',...
   'k','markersize',2,'linestyle','none');

h(1)=plot(ax,smoothAction,'color',[0.7 0.7 0.7],'linestyle','-','linewidth',1.2);

h(2)=plot(ax,NaN,NaN,'Color','b','linestyle','-','linewidth',2);

h(3)=plot(ax,NaN,NaN,'Color','k','linestyle','-','linewidth',2);

h(4)=plot(ax,NaN,NaN,'Color','r','linestyle','-','linewidth',2);


ylim(ax,[-0.05 1.05])
xlim(ax,[0 plotLen])

xlabel(ax,'Trial number')
ylabel(ax,'Fraction rightward choice')

legend(h,'Actions','Left reward','No extra reward','Right reward',...
   'location','northoutside','orientation','horizontal')


end