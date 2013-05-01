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

% Tests our Backpropagation Neural Net
% @author William Harding <wpharding1@gmail.com>

clc
clear all
close all

slopeOfLinearFunction = 2;
maxOfFunction         = 5;

inputs = [0:0.05:maxOfFunction];
% inputs = mapminmax(inputs);
expectedOutputs = exp(-inputs);
% expectedOutputs = slopeOfLinearFunction*inputs;
neuralNet=BackpropNeuralNet(1,100,1);
neuralNet.train(10, 0.001, inputs, expectedOutputs);

%Generate Test Data
testingInputs = [0:0.06:maxOfFunction];
% testingInputs = mapminmax(testingInputs);
testingExpectedOutputs = exp(-testingInputs);
% testingExpectedOutputs = slopeOfLinearFunction*testingInputs;
outputs=neuralNet.run(testingInputs);

derivatives = neuralNet.dOfYWithRespectedToX(testingInputs);
[derivativesOfError, Error] = neuralNet.dOfErrorWithRespectedToX(testingInputs, expectedOutputs);

figure;
plot(testingInputs, outputs, 'ro', ...
     testingInputs, testingExpectedOutputs, 'bo', ...
     testingInputs, derivatives, 'b', ...
     testingInputs, derivativesOfError, 'y', ...
     testingInputs, Error, 'go');
title('blue is desired output, red is actual output, solid is slope of red');

%___________________________________________________________________________
% clc
% clear all
%% Test Neural Net with Hyperbolic Tangent Function at Output
% 
% load('iris3class.mat');
% 
% binaryNet = BackpropNeuralNet(4, 10, 2);
% binaryNet.setOutputTransferFunction(HyperbolicTangent);
% 
% [dataRows, dataCols] = size(data);
% 
% % Shuffle the data
% shuffle_seq = randperm(dataRows);
% for row = 1:1:dataRows
%     data_shuffled(row, :) = data(shuffle_seq(row), :);
% end;
% 
% % Normalize data
% mean1 = [mean(data(:, 1:4)')';0];         % mean of the original data
% max1  = [max(abs(data(:, 1:4)'))';1];% max of the original data
% norData = mapminmax(data_shuffled');
% 
% percentageOfDataForTraining = 2/3;
% numOfTrainingData = floor(dataRows*percentageOfDataForTraining);
% trainingData = norData(:, 1:numOfTrainingData);
% testingData  = norData(:, numOfTrainingData+1:dataRows);
% [amountOfTestingDataRows, amountOfTestingData] = size(testingData);
% 
% binaryNet.train(10, 0.001, trainingData(1:4, :), trainingData(5:6, :));
% 
% %% test resulting network
% y = binaryNet.run(testingData(1:4, :)); % Compute the output
% dError = binaryNet.dOfErrorWithRespectedToX(testingData(1:4, :), testingData(5:6, :));
% 
% for o = 1:1:length(y)
%     if y(1, o) >= 0
%         finalY(1, o) = 1;
%     else
%         finalY(1, o) = -1;
%     end
% 
%     if y(2, o) >= 0
%         finalY(2, o) = 1;
%     else
%         finalY(2, o) = -1;
%     end
% end
% 
% numberOfMisclassified = 0;
% for output = 1:1:length(finalY)
%     if ~isequal(finalY(1:2, output), testingData(5:6, output))
%         numberOfMisclassified = numberOfMisclassified + 1;
%     end
% end
%         
% percentageCorrect = (1 - numberOfMisclassified/amountOfTestingData) * 100;
% percentageCorrect
% 
