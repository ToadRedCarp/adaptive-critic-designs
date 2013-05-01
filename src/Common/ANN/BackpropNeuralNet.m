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

% Neural Network using Backpropagation
% @author William Harding <wpharding1@gmail.com>

classdef BackpropNeuralNet < handle
    properties (GetAccess=private)
        numInputNodes
        numHiddenNodes
        numOutputNodes
        
        HiddenTransferFunction
        OutputTransferFunction

        normalizeAtHiddenLayer
    end
    
    properties
        bias
        weights
        prevWeights
    end
    
    methods
        
        %Constructor
        function obj = BackpropNeuralNet(numInputNodes, numHiddenNodes, numOutputNodes) 
           obj.numInputNodes  = numInputNodes;
           obj.numHiddenNodes = numHiddenNodes;
           obj.numOutputNodes = numOutputNodes;
           
           %initialize weights and biases
           obj.bias{1}        = 1;
           obj.bias{2}        = 1;
           obj.weights{1}     = rand(numHiddenNodes, numInputNodes + 1);
           obj.weights{2}     = rand(numOutputNodes, numHiddenNodes + 1);
           obj.prevWeights{1} = zeros(numHiddenNodes, numInputNodes + 1);
           obj.prevWeights{2} = zeros(numOutputNodes, numHiddenNodes + 1);
           
           obj.HiddenTransferFunction = HyperbolicTangent;
           obj.OutputTransferFunction = LinearFunction;

           obj.normalizeAtHiddenLayer = 0;
        end

        
        function turnOnNormalizationAtHiddenLayer(obj)
            obj.normalizeAtHiddenLayer = 1;
        end

        function setInputLayerWeights(obj, new_weights, new_bias)
            obj.weights{1} = [new_weights new_bias];
        end
        
        function setHiddenLayerWeights(obj, new_weights, new_bias)
            obj.weights{2} = [new_weights new_bias];
        end
        
        function setOutputTransferFunction(obj, func)
            obj.OutputTransferFunction = func;
        end
        
        function setHiddenTransferFunction(obj, func)
            obj.HiddenTransferFunction = func;
        end
        
        %Getters
        function num = getNumInputNodes(obj)
            num = obj.numInputNodes;
        end
        
        function num = getNumHiddenNodes(obj)
            num = obj.numHiddenNodes;
        end
        
        function num = getNumOutputNodes(obj)
            num = obj.numOutputNodes;
        end
        
        function outputs=run(obj, inputs)
            
            [inputDataRows, inputDataCols] = size(inputs);
            for input = 1:1:inputDataCols
                %%Forward Pass
                firstLayerInput = [inputs(:, input)' obj.bias{1}];
                firstLayerV = firstLayerInput * obj.weights{1}';
                firstLayerOutputY = obj.HiddenTransferFunction.TheFunction(firstLayerV);

                secondLayerV = [firstLayerOutputY obj.bias{2}] * obj.weights{2}';
                secondLayerOutputY = obj.OutputTransferFunction.TheFunction(secondLayerV);
            end
            outputs = secondLayerOutputY;
%             [inputDataRows, inputDataCols] = size(inputs);
%             
%             inputsAndBias = [inputs; ones(1, inputDataCols)];
%             
%             firstLayerV = inputsAndBias' * obj.weights{1}';
% 
%             firstLayerOutputY = obj.HiddenTransferFunction.TheFunction(firstLayerV);
% 
%             secondLayerV = [firstLayerOutputY ones(inputDataCols, 1)] * obj.weights{2}';
% 
%             secondLayerOutputY = obj.OutputTransferFunction.TheFunction(secondLayerV);
%             
%             outputs = secondLayerOutputY;
        end
        
        %%dOfYWithRespectedToX
        % inputs - inputs that we desire to find the derivative with
        % respect to.
        %
        % derivatives - a vector of derivatives corresponding to each set
        % of inputs.  Right now give the derivative w.r.t the bias at the
        % input node as well.
        function derivatives=dOfYWithRespectedToX(obj, inputs)
            
            [inputDataRows, inputDataCols] = size(inputs);
            for input = 1:1:inputDataCols
                
                %%Forward Pass
                firstLayerInput = [inputs(:, input)' obj.bias{1}];
                firstLayerV = firstLayerInput * obj.weights{1}';
                firstLayerOutputY = obj.HiddenTransferFunction.TheFunction(firstLayerV);
                secondLayerV = [firstLayerOutputY obj.bias{2}] * obj.weights{2}';

                %% Backpropogation
                
                %Hidden Layer (only use 1 through numHiddenNodes for hidden
                %layer weights; because the last one is the hidden layer
                %bias).
                derivsOfInputsAndBias(:, input) = obj.OutputTransferFunction.TheDerivative(secondLayerV)*(obj.weights{2}(1:obj.numHiddenNodes) .* ...
                                                  (obj.HiddenTransferFunction.TheDerivative(firstLayerV)))*obj.weights{1};
            end
            
            %We only want to return the derivative of the input, not
            % the derivative of the bias.
            derivatives = derivsOfInputsAndBias(1:obj.numInputNodes, :);
        end
        
        function [derivatives, errors]=dOfErrorWithRespectedToX(obj, inputs, expectedOutput)
            
            [inputDataRows, inputDataCols] = size(inputs);
            for input = 1:1:inputDataCols
                %%Forward Pass
                firstLayerInput = [inputs(:, input)' obj.bias{1}];
                firstLayerV = firstLayerInput * obj.weights{1}';
                firstLayerOutputY = obj.HiddenTransferFunction.TheFunction(firstLayerV);

                secondLayerV = [firstLayerOutputY obj.bias{2}] * obj.weights{2}';
                secondLayerOutputY = obj.OutputTransferFunction.TheFunction(secondLayerV);

                % find error
                error(:, input) = expectedOutput(input) - secondLayerOutputY';

                %% Backpropogation
                
                %Hidden Layer
                % dE/dx = (dE/dy{2})(dy{2}/dv{2})(dv{2}/dy{1})(dy{2}/dv{1})(dv{1}/dx{1})
                % dE/dy{2} = error
                derivsOfInputsAndBias(:, input) = (error(:, input) * ...
                                                  obj.OutputTransferFunction.TheDerivative(secondLayerV))' * ...
                                                  obj.weights{2}(:, 1:obj.numHiddenNodes) .* ... % should we drop first or last col?
                                                  obj.HiddenTransferFunction.TheDerivative(firstLayerV) * ...
                                                  obj.weights{1}(:,1:obj.numInputNodes);
   
            end
            
            %We only want to return the derivative of the inputs, not
            % the derivative of the bias.
            derivatives = derivsOfInputsAndBias(1:obj.numInputNodes, :);
            errors      = error;
        end
        
        
        %%Neural Network Train Function
        % epochs         = max number of epochs
        % eta            = learning rate
        % inputs         = column vector of inputs
        % expectedOutput = column vector of expected outputs
        function mse=train(obj, epochs, eta, inputs, expectedOutput)
            
            [inputDataRows, inputDataCols] = size(inputs);
            
            for epoch = 1:1:epochs
                for input = 1:1:inputDataCols

                    %%Forward Pass
                    firstLayerInput = [inputs(:, input)' obj.bias{1}];
                    firstLayerV = firstLayerInput * obj.weights{1}';
                    firstLayerOutputY = obj.HiddenTransferFunction.TheFunction(firstLayerV);
                    secondLayerV = [firstLayerOutputY obj.bias{2}] * obj.weights{2}';
                    secondLayerOutputY = obj.OutputTransferFunction.TheFunction(secondLayerV);

                    % find error
                    error(:, input) = expectedOutput(:, input) - secondLayerOutputY';

                    %% Backpropogation
                    % Output Layer
                    secondLayerDelta = error(:, input).*obj.OutputTransferFunction.TheDerivative(secondLayerV)';

                    %Hidden Layer
                    firstLayerDelta = (obj.HiddenTransferFunction.TheDerivative(firstLayerV)) .* ...
                                      ((obj.weights{2}(:, 1:obj.numHiddenNodes)'*secondLayerDelta))';
                                  

                    % Store the current weights
                    obj.prevWeights = obj.weights;

                    % Update weights at second layer
                    obj.weights{2} = obj.prevWeights{2} + eta*secondLayerDelta*[firstLayerOutputY obj.bias{2}];

                    obj.weights{1} = obj.prevWeights{1} + eta*firstLayerDelta'*firstLayerInput;
                end

                mse(epoch) = sum(mean(error.^2));
            end 
        end
        
        %%Neural Network Train Function
        % epochs         = max number of epochs
        % eta            = learning rate
        % inputs         = row vector of inputs
        % expectedOutput = row vector of expected outputs
        function mse=trainActorWithCriticConnected(obj, epochs, eta, inputs, critic, outputs, actorActionOutputsStart, actorActionOutputsFinish)
            
            [inputDataRows, inputDataCols] = size(inputs);
            
            for epoch = 1:1:epochs
                for input = 1:1:inputDataCols

                    %%Forward Pass
                    firstLayerInput = [inputs(:, input)' obj.bias{1}];
                    firstLayerV = firstLayerInput * obj.weights{1}';
                    firstLayerOutputY = obj.HiddenTransferFunction.TheFunction(firstLayerV);
                    secondLayerV = [firstLayerOutputY obj.bias{2}] * obj.weights{2}';
                    secondLayerOutputY = obj.OutputTransferFunction.TheFunction(secondLayerV);

                    %pass to critic
                    errorAtInput = critic.dOfErrorWithRespectedToX([inputs(:, input); secondLayerOutputY'], outputs(input));
                   
                    error(:, input) = errorAtInput(actorActionOutputsStart:actorActionOutputsFinish, :); %this three needs to be updated to be variable (5 if cart pole)
                    
                    %% Backpropogation

                    % Output Layer
                    secondLayerDelta = error(:, input).*obj.OutputTransferFunction.TheDerivative(secondLayerV)';

                    %Hidden Layer
                    firstLayerDelta = (obj.HiddenTransferFunction.TheDerivative(firstLayerV)) .* ...
                                      ((obj.weights{2}(:, 1:obj.numHiddenNodes)'*secondLayerDelta))';

                    obj.prevWeights = obj.weights;

                    %% Update Weights
                    obj.weights{2} = obj.prevWeights{2} + eta*secondLayerDelta*[firstLayerOutputY obj.bias{2}];

                    obj.weights{1} = obj.prevWeights{1} + eta*firstLayerDelta'*firstLayerInput;
                end

                mse(epoch) = sum(mean(error.^2));
            end 
        end
        
        function mse=trainWithSpecifiedError(obj, epochs, eta, inputs, error)
            
            [inputDataRows, inputDataCols] = size(inputs);
            
            for epoch = 1:1:epochs
                for input = 1:1:inputDataCols

                    %%Forward Pass
                    firstLayerInput = [inputs(:, input)' obj.bias{1}];
                    firstLayerV = firstLayerInput * obj.weights{1}';
                    firstLayerOutputY = obj.HiddenTransferFunction.TheFunction(firstLayerV);
                    secondLayerV = [firstLayerOutputY obj.bias{2}] * obj.weights{2}';
                    secondLayerOutputY = obj.OutputTransferFunction.TheFunction(secondLayerV);
                    
                    %% Backpropogation

                    % Output Layer
                    secondLayerDelta = error(:, input).*obj.OutputTransferFunction.TheDerivative(secondLayerV)';

                    %Hidden Layer
                    firstLayerDelta = (obj.HiddenTransferFunction.TheDerivative(firstLayerV)) .* ...
                                      ((obj.weights{2}(:, 1:obj.numHiddenNodes)'*secondLayerDelta))';

                    obj.prevWeights = obj.weights;

                    %% Update Weights
                    obj.weights{2} = obj.prevWeights{2} + eta*secondLayerDelta*[firstLayerOutputY obj.bias{2}];

                    obj.weights{1} = obj.prevWeights{1} + eta*firstLayerDelta'*firstLayerInput;
                end

                mse(epoch) = sum(mean(error.^2));
            end 
        end
    end
end