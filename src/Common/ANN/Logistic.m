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

% Hyperbolic Tangent Transfer Function
% @author William Harding <wpharding1@gmail.com>

classdef Logistic < TransferFunction
    methods (Static)
        function output = TheFunction(input)
            output = (1./(1+exp(-input)));
        end

        function derivative = TheDerivative(input)
            derivative = exp(-input)/(exp(-input) + 1).^2;
        end
    end
end