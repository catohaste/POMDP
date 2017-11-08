
function output = RunPOMDP(input,params)


alpha    = params(1);
rho      = params(2);
noiseSTD = params(3);

stimTrials = input.stimTrials;
extraReward = input.extraRewardTrials;


% set run numbers
iterN = 21;  % model values are averaged over iterations
trialN = length(stimTrials);


% initialise variables, for speed
action	= cell(trialN,iterN);
QL			= zeros(trialN,iterN);
QR			= zeros(trialN,iterN);
delta		= zeros(trialN,iterN);


for iter = 1:iterN
	
	% initalise Q values for each iteration
	QLL(1,:) = 1;
	QRR(1,:) = 1;
	QLR(1,:) = 0;
	QRL(1,:) = 0;
	
	% start model
	for trial=1:trialN
		
		
		% set contrast
		currentStim = stimTrials(trial);
		
		% add sensory noise
		stim_withnoise  = currentStim + noiseSTD * randn;
		
		
		% calculate belief
		Belief_L = normcdf(0,stim_withnoise,noiseSTD);
		Belief_R = 1 - Belief_L;
		
		
		%initialise Q values for this iteration
		QL(trial,iter) = Belief_L*QLL + Belief_R*QRL  ;
		QR(trial,iter) = Belief_L*QLR + Belief_R*QRR  ;
		
		
		% action <-- max(QL,QR)
		if QL(trial,iter) > QR(trial,iter)
			
			action{trial,iter} = 'left';
			
		elseif QL(trial,iter) < QR(trial,iter)
			
			action{trial,iter} = 'right';
			
		else
			
			if rand >= 0.5
				action{trial,iter} = 'right';
			else
				action{trial,iter} = 'left';
			end
			
		end
		
		% trial reward for action chosen by agent
		if currentStim<0 && strcmp(action{trial,iterN},'left')
			
			switch extraReward{trial}
				case 'left'
					reward = 1 + rho;
				case 'right'
					reward = 1;
				case 'none'
					reward = 1;
			end
			
		elseif currentStim>0 && strcmp(action{trial,iter},'right')
			
			switch extraReward{trial}
				case 'left'
					reward = 1;
				case 'right'
					reward = 1 + rho;
				case 'none'
					reward = 1;
			end
			
		elseif currentStim==0
			
			if rand > 0.5
				
				if strcmp(action{trial,iterN},'left')
					
					switch extraReward{trial}
						case 'left'
							reward = 1 + rho;
						case 'right'
							reward = 1;
						case 'none'
							reward = 1;
					end
					
				elseif strcmp(action{trial,iterN},'right')
					
					switch extraReward{trial}
						case 'left'
							reward = 1 + rho;
						case 'right'
							reward = 1;
						case 'none'
							reward = 1;
					end
					
				end
				
			else
				
				reward = 0 ;
				
			end
			
		else
			
			reward = 0 ;
			
		end
		
		
		% calculate delta, and update Q values
		if strcmp(action{trial,iterN},'left')
			
			delta(trial, iter)   = reward - QL(trial,iter);
			
			QLL     = QLL + alpha * delta(trial,iter) * Belief_L ;
			QRL     = QRL + alpha * delta(trial,iter) * Belief_R ;
			
		else   % right
			
			delta(trial, iter)   = reward - QR(trial,iter);
			
			QLR     = QLR + alpha * delta(trial,iter) * Belief_L;
			QRR     = QRR + alpha * delta(trial,iter) * Belief_R;
			
		end
		
	end
	
end

actionLeft = strcmp(action,'left');
actionRight = strcmp(action,'right');
meanActionNum = mean(actionRight-actionLeft,2);

% set output
output.action = meanActionNum;
output.QL			= mean(QL,2);
output.QL			= mean(QR,2);


end
