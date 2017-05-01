
function output = RunPOMDP(input,params)


alpha    = params(1);
rho      = params(2);
noiseSTD = params(3);

stimTrials = input(:,1);


% outcomes of correct trials:

%         blk1     blk2
reward = [1+rho,   1      ; % L action
          1    ,   1+rho] ; % R action


% set run numbers
iterN = 21;  % model values are averaged over iterations
trialN = length(stimTrials);


% initialise variables, for speed
action = nan(trialN,iterN);
QL = nan (trialN,iterN);
QR = nan (trialN,iterN);
delta = nan (trialN,iterN);

 
for iter = 1:iterN
   
   % initalise Q values for each iteration
   QLL(1,:) = 1;
   QRR(1,:) = 1;
   QLR(1,:) = 0;
   QRL(1,:) = 0;
   
   % start model
   for trials = 1 : trialN
      

      % set contrast
      currentStim = stimTrials(trials);
      
      % add sensory noise
      stim_withnoise  = currentStim + noiseSTD * randn;

      
      % calculate belief
      Belief_L = normcdf(0,stim_withnoise,noiseSTD);
      Belief_R = 1 - Belief_L;
      
      
      %initialise Q values for this iteration
      QL(trials,iter) = Belief_L*QLL + Belief_R*QRL  ;
      QR(trials,iter) = Belief_L*QLR + Belief_R*QRR  ;
      
      
      % action <-- max(QL,QR)
      if QL(trials,iter) > QR(trials,iter)
         
         action(trials,iter) = -1;
         
      elseif QL(trials,iter) < QR(trials,iter)
         
         action(trials,iter) = 1;
         
      else
         
         if rand > 0.5
            action(trials,iter) = 1;
         else
            action(trials,iter) = -1; 
         end
         
      end


      % trial reward for action chosen by agent
      if currentStim<0 && action(trials,iter)==-1
         
         Reward = reward(1,input(trials,2));
         
      elseif currentStim>0 && action(trials,iter)==1
         
         Reward = reward(2,input(trials,2));
         
      elseif currentStim==0
         
         if rand > 0.5
            
            if action(trials,iter)==-1
               
               Reward = reward(1,input(trials,2));
               
            elseif action(trials,iter)==1
               
               Reward = reward(2,input(trials,2));
               
            end
            
         else
            
            Reward = 0 ;
            
         end
         
      else
         
         Reward = 0 ;
         
      end
      
      
      % calculate delta, and update Q values
      if action(trials,iter) == -1  % left
         
         delta(trials, iter)   = Reward - QL(trials,iter);
         
         QLL     = QLL + alpha * delta(trials,iter) * Belief_L ;
         QRL     = QRL + alpha * delta(trials,iter) * Belief_R ;
         
      else   % right
         
         delta(trials, iter)   = Reward - QR(trials,iter);
         
         QLR     = QLR + alpha * delta(trials,iter) * Belief_L;
         QRR     = QRR + alpha * delta(trials,iter) * Belief_R;
         
      end
      
   end
   
end

% set output
output = [mean(action,2), mean(QL,2), mean(QR,2)];


end
