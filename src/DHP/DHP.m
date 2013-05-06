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

% DHP (Dual Heuristic Dynamic Programming)
% @author William Harding <wpharding1@gmail.com>

clc
clear all
close all

mfilepath=fileparts(which(mfilename));
addpath(fullfile(mfilepath,'../Common/ANN'));
addpath(fullfile(mfilepath,'../Common/Plant'));
addpath(fullfile(mfilepath,'../Common/GUI'));
addpath(fullfile(mfilepath,'../HDP'));

% indices into state vector
thetaIndex    = 1;
thetaDotIndex = 2;
xIndex        = 3;
xDotIndex     = 4;
    
timeStep = 1;
stateVector(:, timeStep) = [0; 0; 0; 0];
[numStates, cols] = size(stateVector(:, timeStep));

discountRate = 0.9;
    
actor = BackpropNeuralNet(numStates, 16, 1);
critic = BackpropNeuralNet(numStates, 20, numStates);
% actor.setHiddenTransferFunction(Logistic);
% critic.setHiddenTransferFunction(Logistic);
cartPole = CartPoleGUI(0, 0);

actor.setMomentum(1);

%turn on/ff simple/complex utility functions
binary_reinforcement = 0;

trials = 100;

actorEpochs          = 1;
criticEpochs         = 1;

for trial = 1:trials

    clear actions;
    clear stateVector;
    clear reinforcementSignal;

%     trial
    
    learningRateActor = 0.01; 
    learningRateCritic = 0.0001;
    
    itFell = 0;

    timeStep = 1;
    stateVector(:, timeStep) = [0; 0; 0; 0];
    [numStates, cols] = size(stateVector(:, timeStep));
    
    boostTheta      = 3/pi;
    boostTheta_dot  = 3;
    boostX          = 0.05; %0.16
    boostX_dot      = 1;
    boostMatrix     = diag([boostTheta, boostTheta_dot, boostX, boostX_dot], 0);
    
    while (true)
        % get next action
        scaledState = boostMatrix*stateVector(:, timeStep);
        actorInput = scaledState;
        actions(timeStep) = actor.run(actorInput);
        
        % Use model to get next state
        stateVector(:, timeStep + 1) = CartPolePlant(stateVector(:, timeStep), actions(timeStep));
      
        %% Get partial derivatives
        if (binary_reinforcement == 1)            
            dOfU_wrt_theta_and_x = DerivativeReinforcementSignalWithSigmoids(scaledState(thetaIndex), scaledState(xIndex));
        else
            dOfU_wrt_theta_and_x = DerivativeReinforcementSignalWithExponentials(scaledState(thetaIndex), scaledState(xIndex));
        end
        
        dOfU_wrt_x = [dOfU_wrt_theta_and_x(1), 0, dOfU_wrt_theta_and_x(2), 0];

        dOfU_wrt_u = 0;
        
        [dOfF_wrt_x, dOfF_wrt_u] = CartPoleModelScriptDerivative(stateVector(:, timeStep), actions(timeStep));

        dOfA_wrt_x = actor.dOfYWithRespectedToX(actorInput);
        
        %% Get G(t+1)
        nextG=critic.run(boostMatrix*stateVector(:, timeStep + 1))/boostMatrix;
%         nextG=critic.run(boostMatrix*stateVector(:, timeStep + 1))*boostMatrix;
        
        criticExpectedOutput = dOfU_wrt_x' + (discountRate * dOfF_wrt_x' * nextG') + ...
                               boostMatrix*dOfA_wrt_x * (dOfU_wrt_u + discountRate * dOfF_wrt_u * nextG');   %todo - multiple or divide by boost
                           
        %GUI Update
        cartPole.update(stateVector(thetaIndex, timeStep + 1) + 90, stateVector(xIndex, timeStep + 1));
        
        %Critic Training
        criticInputs = (boostMatrix*stateVector(:, timeStep));
        criticError = (criticExpectedOutput' - critic.run(criticInputs))/boostMatrix;
        criticMse = critic.trainWithSpecifiedError(criticEpochs, learningRateCritic, criticInputs, criticError');
        
%         criticInputs = (stateVector(:, timeStep)'/boostMatrix)';
%         criticOutput = (criticExpectedOutput'/boostMatrix)';
%         criticMse = critic.train(criticEpochs, learningRateCritic, criticInputs, criticOutput);
        
        %% Get G(t+1)
        nextG=critic.run(boostMatrix*stateVector(:, timeStep + 1))/boostMatrix;
%         nextG=critic.run(boostMatrix*stateVector(:, timeStep + 1))*boostMatrix;
        
        %Actor Training
        actorError = (dOfU_wrt_u + discountRate * dOfF_wrt_u * nextG');
        actorMse = actor.trainWithSpecifiedError(actorEpochs, learningRateActor, actorInput, actorError);

        if (timeStep > 2000)
            fprintf('We are the champions, my friend!');
            break;
        end
        
        
        itFell = ...
          ( ( stateVector(xIndex, timeStep) >= 2.4 || ...
              stateVector(xIndex, timeStep) <= -2.4 ) || ...
            ( stateVector(thetaIndex, timeStep) >= 12 || ...
              stateVector(thetaIndex, timeStep) <= -12  ) );
        
        if (itFell == 1)
            break;
        end

        timeStep = timeStep + 1;
    end
    
    %Final Critic Training
    criticInputs = (boostMatrix*stateVector(:, timeStep));
    criticError = (dOfU_wrt_x - critic.run(criticInputs))/boostMatrix;
    criticMse = critic.trainWithSpecifiedError(criticEpochs, learningRateCritic, criticInputs, criticError');
        
    
    [row, numActions(trial)] = size(actions);
%     numActions(trial)
end



