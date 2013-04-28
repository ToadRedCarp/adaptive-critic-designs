% Copyright (c) 2013 William Harding
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

clc
clear all
close all

mfilepath=fileparts(which(mfilename));
addpath(fullfile(mfilepath,'../../ANN/'));
addpath(fullfile(mfilepath,'../../Cart_Pole_Lui/'));

% indices into state vector
thetaIndex    = 1;
thetaDotIndex = 2;
xIndex        = 3;
xDotIndex     = 4;

tries = 1;
while tries <= 10

    clear actions;
    clear stateVector;
    
    stateIndex = 1;
    stateVector(:, stateIndex) = [0; 0; 0; 0];
    [numStates, cols] = size(stateVector(:, stateIndex));

    discountRate = 0.9;

    actor =  BackpropNeuralNet(numStates,     4, 1);
    model =  BackpropNeuralNet(numStates + 1, 6, 4);
    critic = BackpropNeuralNet(numStates + 1, 6, 1);
    
    %% Train the Model
    
    for i=1:1000 
        randomState = rand(1,4) * 20;
        randomAction = rand(1) * 20 - 10;
        plantInputs(i,:) = [ randomState, randomAction ];
        plantOutputs(i,:) = plant(randomState, randomAction)';
    end
    
    mse = model.train(300, 0.0001, plantInputs', plantOutputs');
    plot(mse);
    
    
    %% Balance the Pole on the Cart
    actionIndex = 1;
   
    while not ((stateVector(xIndex, stateIndex) >= 2.4 || stateVector(xIndex, stateIndex) <= -2.4) || ...
               (stateVector(thetaIndex, stateIndex) >= 12 || stateVector(thetaIndex, stateIndex) <= -12) || ...
               actionIndex > 1000)
           
        if(actionIndex == 1)
            fprintf('Still standing . . .\n');
        end
        
        input = mapminmax(stateVector(:, stateIndex)')';
        actions(actionIndex) = actor.run(input);
        stateVector(:, stateIndex + 1) = plant(stateVector(:, stateIndex), actions(actionIndex));
        stateIndex = stateIndex + 1;
        actionIndex = actionIndex + 1;
        
    end
    
    %% Print the actionIndex
    actionIndex
    % Since we never actually ran the last index, decrement.
    
    %% Train the Critic
    actionIndex = actionIndex - 1;

    fprintf('It Fell!\n');
    fprintf('Let us train ye olde critic!\n');

    % train the critic
    for time = 1:actionIndex
        expectedOutputs(time) = discountRate^(actionIndex - time);
    end

    
    
    criticInputs = mapminmax([stateVector(:, 1:stateIndex - 1); actions]')';
    criticOutputs = mapminmax(expectedOutputs')';
    criticMse=critic.train(1000, 0.0001, criticInputs, criticOutputs);
    
    %% Train the actor
    actorCriticExpectedOutputs = zeros(1, stateIndex);
    actorInputs = mapminmax(stateVector(:, 1:stateIndex - 1)')';
    actorMse = actor.trainWithSpecifiedError(1000, 0.001, actorInputs, critic, actorCriticExpectedOutputs);
    
    tries = tries + 1;
end

