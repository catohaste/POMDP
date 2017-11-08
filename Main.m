% INPUT DATA STRUCTURE
% each row represents a single trial
% column 1 -> stimulus values for each trial,
%              one of [-0.5 -0.2 -0.1 -0.05 0.05 0.1 0.2 0.5];
% column 2 -> rewardBlockID,
%              1 when agent receives reward for correct LEFT choice
%              2 when agent received reward for correct RIGHT choice

clear
close all

%% SET MODEL PARAMETER VALUES

% set model parameter values
alpha       = 0.35;     % learning rate
rho         = 4.0;      % value of additional reward
noiseSTD    = 0.18;     % noise in belief

params = [alpha rho noiseSTD];


%% SET TASK PARAMETER VALUES

trialN			= 4000;													% number of trials
blockN			= 20;														% number of blocks
extraReward = {'right','left','none'};			% options for extra reward side
stimulus = ...
	[-0.5 -0.2 -0.1 -0.05 0.05 0.1 0.2 0.5];	% possible stimulus values


%% GENERATE INPUT DATA

% create input struct
input	= struct;


% initialise array to hold stimulus values for each trial
input.stimTrials = zeros(trialN,1);

for i=1:trialN
	% here, a 'for' loop is used to ensure a different random number is
	% generated on each iteration
	
	% input.stimTrials(i) = (ceil(rand*26)-13.5)*0.04;
	input.stimTrials(i) = stimulus(unidrnd(length(stimulus)));
	
end

% choose lengths of each block
midBlockLen = trialN/blockN;
minBlockLen = 0.75*midBlockLen;
maxBlockLen = 1.25*midBlockLen;
rangeBlockLen = minBlockLen:maxBlockLen;
blockLen = randsample(rangeBlockLen,blockN-1,true);

% ensure block lengths add up to total trial number
if sum(blockLen)<trialN
	blockLen = [blockLen trialN-sum(blockLen)];
else
	blockLen(9) = trialN - sum(blockLen(1:8));
end

% calculate cumulative sum of block lengths
blockLenCumul = cumsum(blockLen);


% initialize cell array for extraRewardTrials
input.extraRewardTrials = cell(trialN,1);

% randomly choose extra reward side for each block
blockID = cell(blockN,1);
blockID(1) = randsample(extraReward,1,true);
for i=2:blockN
	blockID(i) = randsample(setdiff(extraReward,blockID{i-1}),1,true);
end

% fill in correct reward for each trial
input.extraRewardTrials(1:blockLenCumul(1)) = blockID(1);
for i=2:blockN
	input.extraRewardTrials(blockLenCumul(i-1):blockLenCumul(i)) ...
		= blockID(i);
end


%% RUN

output = RunPOMDP(input,params);

%% PLOTS

% PLOT PSYCHOMETRIC FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PlotPsycho(input,output)


% PLOT TRIAL BY TRIAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PlotTrials(input,output)

