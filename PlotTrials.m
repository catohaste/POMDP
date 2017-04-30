function PlotTrials(input,output)

% changing y-axis values
output(:,1) = (1 + output(:,1)) ./ 2;

plotLen = length(input);
plotLenVec = cat(1,ones(plotLen,1),zeros(length(input)-plotLen,1));

action = output(plotLenVec==1,1);

smoothAction = smooth(action,7);


block1 = input(plotLenVec==1,2);
block1(input(:,2)==1) = -0.03;
block1(input(:,2)~=1) = NaN;

block2 = input(plotLenVec==1,2);
block2(input(:,2)==2) = 1.03;
block2(input(:,2)~=2) = NaN;


fig = figure('Position', [100, 100, 1200, 350]);
ax = axes(fig,'position',[0.05,0.14,0.93,0.86],'fontsize',16); hold on

plot(ax,block1,'marker','o','MarkerEdgeColor','b','markerfacecolor',...
   'b','markersize',2,'linestyle','none');

plot(ax,block2,'marker','o','MarkerEdgeColor','r','markerfacecolor',...
   'r','markersize',2,'linestyle','none');

h(1)=plot(ax,smoothAction,'color',[0 0 0],'linestyle','-','linewidth',1.2);

h(2)=plot(ax,NaN,NaN,'Color','b','linestyle','-','linewidth',2);

h(3)=plot(ax,NaN,NaN,'Color','r','linestyle','-','linewidth',2);


ylim(ax,[-0.05 1.05])
xlim(ax,[0 plotLen])

xlabel(ax,'Trial number')
ylabel(ax,'Fraction rightward choice')

legend(h,'Actions','Left reward','Right reward',...
   'location','northoutside','orientation','horizontal')


end