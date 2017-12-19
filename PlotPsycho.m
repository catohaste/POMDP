function PlotPsycho(input,output)

% change the y-axis from (-1,1) to (0,1)
output.action = (1 + output.action) ./ 2;

perStim = nan(1,length(unique(input.stimTrials)));

% PLOT
figure; hold on

for iBlock = unique(input.extraRewardTrials)'
	c=1;
	for iStim = unique(input.stimTrials)'
		
		perStim(c)= mean(output.action(input.stimTrials==iStim &...
			strcmp(input.extraRewardTrials,iBlock)),1);
		
		c=c+1;
	end
	
	if strcmp(iBlock,'left')
			color = [0 0 1];
	elseif strcmp(iBlock,'right')
			color = [1 0 0];
	elseif strcmp(iBlock,'none')
			color = [0 0 0];
	end
	
	plot(unique(input.stimTrials)',perStim,'Color',color,...
		'marker','o','markersize',10,'linestyle','-','linewidth',1.2)
	ylabel('Fraction rightward choice')
	xlabel('Stimulus')
	ylim([0 1])
	title ('Psychometric function of POMDP Model')
	
end

legend('Reward after L action','No extra reward','Reward after R action'...
	,'Location','southeast')

end
