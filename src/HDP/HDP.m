% Copyright (c) 2013 William Harding and Jonathan McCluskey.
% 
% Permission is hereby granted, free of charge, to any person obtaining 
% a copy of this software and associated documentation files (the "Software"),
% to deal in the Software without restriction, including without limitation 
% the rights to use, copy, modify, merge, publish, distribute, sublicense, 
% and/or sell copies of the Software, and to permit persons to whom the 
% Software is furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in
% all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
% SOFTWARE.

% HDP (Heuristic Dynamic Programming)
% @author Jonathan McCluskey <jonathan.m.mccluskey@gmail.com>

clc
clear all
close all

mfilepath=fileparts(which(mfilename));
addpath(fullfile(mfilepath,'../Common/ANN'));
addpath(fullfile(mfilepath,'../Common/Plant'));
addpath(fullfile(mfilepath,'../Common/GUI'));


% indices into state vector
thetaIndex    = 1;
thetaDotIndex = 2;
xIndex        = 3;
xDotIndex     = 4;
    
timeStep = 1;
stateVector(:, timeStep) = [0; 0; 0; 0];
[numStates, cols] = size(stateVector(:, timeStep));

discountRate = 0.9;
    
actor = BackpropNeuralNet(numStates, 4, 1);
critic = BackpropNeuralNet(numStates, 6, 1);
cartPole = CartPoleGUI(0, 0);

max_x       = 2.4;
max_theta   = 12;

%turn on/ff simple/complex utility functions
binary_reinforcement = 0;

learningRateActor = 0.01; 
learningRateCritic = 0.01;

for trial = 1:100

    clear actions;
    clear stateVector;

    trial
    
    itFell = 0;

    timeStep = 1;
    stateVector(:, timeStep) = [0; 0; 0; 0];
    [numStates, cols] = size(stateVector(:, timeStep));
    
    while (true)
        actorInput = mapminmax(stateVector(:, timeStep)')';
        actions(timeStep) = actor.run(actorInput);
        
        stateVectorNext = model(actorInput,actions(timeStep));
        dNextState = dModeldX(actorInput,actions(timeStep));
        
        criticInputsNext = mapminmax(stateVectorNext')';
        Jt1=critic.run(criticInputsNext);
        
        itFell = ...
          ( ( stateVector(xIndex, timeStep) >= 2.4 || ...
              stateVector(xIndex, timeStep) <= -2.4 ) || ...
            ( stateVector(thetaIndex, timeStep) >= 12 || ...
              stateVector(thetaIndex, timeStep) <= -12  ) );

        if (binary_reinforcement == 1)
            reinforcementSignal(timeStep) = itFell;
        else
            maxR = (max_x)^5 + (max_theta)^2;
            reinforcementSignal(timeStep) = (stateVector(xIndex, timeStep)^5 + stateVector(thetaIndex, timeStep)^2)/maxR;
        end
        
        stateVector(:, timeStep + 1) = CartPolePlant(stateVector(:, timeStep), actions(timeStep));

        %GUI Update
        cartPole.update(stateVector(thetaIndex, timeStep + 1) + 90, stateVector(xIndex, timeStep + 1));
        
        %Critic Training
        criticOutput = reinforcementSignal(timeStep) + discountRate * Jt1;
        criticInputs = mapminmax(stateVector(:, timeStep)')';
        criticMse = critic.train(10, learningRateCritic, criticInputs, criticOutput);
        
        %Actor Training
        actorCriticExpectedOutputs = 0;
        [dEdX,tmp] = critic.dOfErrorWithRespectedToX(criticInputs, actorCriticExpectedOutputs);
        dXdu = dNextState(5,:);
        actorMse = actor.trainWithSpecifiedError(10, learningRateActor, actorInput, dXdu*dEdX);

        if (timeStep > 2000)
            fprintf('We are the champions, my friend!');
            break;
        end
                  
        if (itFell == 1)
            break;
        end

        timeStep = timeStep + 1;
    end
    
    [row, numActions(trial)] = size(actions);
    numActions(trial)
end

