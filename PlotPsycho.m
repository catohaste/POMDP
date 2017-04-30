function PlotPsycho(input,output)

color=[0 0 1; 1 0 0];   % blue, red

% change the y-axis from (-1,1) to (0,1)
output(:,1) = (1 + output(:,1)) ./ 2;

perStim = nan(1,length(unique(input(:,1))));

% PLOT
figure; hold on

for iBlock = unique(input(:,2))'
   c=1;
   for iStim = unique(input(:,1))'
      
      perStim(c)= nanmean(output(input(:,1)==iStim &...
         input(:,2)==iBlock,1));
      
      c=c+1;
   end

   plot(unique(input(:,1))',perStim,'Color',color(iBlock,:),...
      'marker','o','markersize',10,'linestyle','-','linewidth',1.2)
   ylabel('Fraction rightward choice')
   xlabel('Stimulus')
   ylim([0 1])
   title ('Psychometric function of POMDP Model')
   
end

legend('Reward after L action','Reward after R action',...
   'Location','southeast')

end
