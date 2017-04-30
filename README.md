#### POMDP

A project building a reinforcement learning algorithm based upon a _partially observable Markov decision process_. 

The ideas used to build the model implemented here are largely drawn from 
* Sutton and Barto
* This other paper.
Terminology and the majority of the notation are also taken from these sources.

#####The task

Here the agent will be presented with a two-alternative forced decision task. Over a number of trials the agent will be able to choose and then perform an action based upon a given stimulus. The stimulus values range from -1 to 1. When the stimulus value is less than 0, the agent should choose Left to make a correct decision, and when the stimulus value is greater than 0 the agent should choose Right to make a correct decision. If the stimulus value is 0, the correct decision is randomly assigned to be either left or right for the given trial, and the agent will be rewarded accordingly.

The agent is reward in an asymmetric manner. For some trials, the agent receives an additional reward for making a left correct action. For the remaining trials, the agent receives an additional reward for making a right correct action. The trials are presented to the agent in blocks.

![Block structure](https://heykayhay.github.com/POMDP/blockReward.png)
![Reward structure](https://heykayhay.github.com/POMDP/reward.png)


#####The model

![POMDP model flowchart](https://heykayhay.github.com/POMDP/POMDPflowchart.png)


#####The code
