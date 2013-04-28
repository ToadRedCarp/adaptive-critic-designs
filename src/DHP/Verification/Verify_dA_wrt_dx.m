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
addpath(fullfile(mfilepath,'../../../../ANN/'));

% indices into state vector
thetaIndex    = 1;
thetaDotIndex = 2;
xIndex        = 3;
xDotIndex     = 4;

stateVector = [0; 0; 0; 0];
[numStates, cols] = size(stateVector);

actor = BackpropNeuralNet(numStates, 16, 1);

stateVector = [0.1; 0.1; 0.1; 0.1];

euclidianVector(:, thetaIndex)      = [1; 0; 0; 0];
euclidianVector(:, thetaDotIndex)   = [0; 1; 0; 0];
euclidianVector(:, xIndex)          = [0; 0; 1; 0];
euclidianVector(:, xDotIndex)       = [0; 0; 0; 1];
epsilon = 0.001;

% get next action
actorInput = mapminmax(stateVector')';

dOfA_wrt_x = actor.dOfYWithRespectedToX(actorInput)

(actor.run(actorInput + epsilon*euclidianVector(:, thetaIndex)) - actor.run(actorInput - epsilon*euclidianVector(:, thetaIndex)))/(2*epsilon) 
(actor.run(actorInput + epsilon*euclidianVector(:, thetaDotIndex)) - actor.run(actorInput - epsilon*euclidianVector(:, thetaDotIndex)))/(2*epsilon) 
(actor.run(actorInput + epsilon*euclidianVector(:, xIndex)) - actor.run(actorInput - epsilon*euclidianVector(:, xIndex)))/(2*epsilon) 
(actor.run(actorInput + epsilon*euclidianVector(:, xDotIndex)) - actor.run(actorInput - epsilon*euclidianVector(:, xDotIndex)))/(2*epsilon) 