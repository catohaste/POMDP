% INPUT DATA STRUCTURE
% each row represents a single trial
% column 1 -> contrast values for each trial,...
%              one of [-0.5 -0.2 -0.1 -0.05 0.05 0.1 0.2 0.5];
% column 2 -> rewardBlockID,
%              1 when agent receives reward for correct LEFT choice
%              2 when agent received reward for correct RIGHT choice


close all

%% SET PARAMETER VALUES

% set model parameter values
alpha       = 0.35;       % learning rate
DA_val      = 7.0;      % dopamine value
noiseSTD    = 0.10;    % noise in belief

params = [alpha DA_val noiseSTD];

%% GENERATE DATA

trialN = 2000;                      % number of trials
blockN = 10;
input = nan(trialN,2);              % create input array

% COLUMN 1 , CONTRAST

contrast = [-0.5 -0.2 -0.1 -0.05 0.05 0.1 0.2 0.5];
contrastTrials = nan(trialN,1);


for i=1:trialN
   % here, a 'for' loop is used to ensure a different random number is
   % generated on each iteration

   %contrastTrials(i) = (ceil(rand*26)-13.5)*0.04;
   contrastTrials(i) = contrast(unidrnd(length(contrast)));

end

% set contrast
input(:,1) = contrastTrials(:);


% COLUMN 2 , REWARD BLOCK ID

midBlockLen = trialN/blockN;
minBlockLen = 0.75*midBlockLen;
maxBlockLen = 1.25*midBlockLen;
rangeBlockLen = minBlockLen:maxBlockLen;
blockLen = randsample(rangeBlockLen,blockN-1,true);

if sum(blockLen)<trialN
   blockLen = [blockLen trialN-sum(blockLen)];
else
   blockLen(9) = trialN - sum(blockLen(1:8));
end

blockLenCumul = cumsum(blockLen);

oddBlockTrials = nan(trialN,1);

for i=1:trialN
   
   oddBlockTrials(i) = mod(sum(i > blockLenCumul) + 1,2);
   
end

evenBlockTrials = 1 - oddBlockTrials;

tmp = randsample([1 2],2);
oddBlockID = tmp(1);
evenBlockID = tmp(2);

input(:,2) = oddBlockID*oddBlockTrials + evenBlockID*evenBlockTrials;


%% RUN

output = RunPOMDP(input,params);

%% PLOTS

% PLOT PSYCHOMETRIC FUNCTION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PlotPsycho(input,output)


% PLOT TRIAL BY TRIAL %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

PlotTrials(input,output)

