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

function y=ReinforcementSignalWithSigmoids(theta, x)
   theta_max = 12;
   x_max     = 2.4;
   steepness = 100;

   %% for theta
   theta_out = (1./(1+exp(-(-steepness*(theta + theta_max))))) + (1./(1+exp(-steepness*(theta - theta_max))));
   
   %% for x
   x_out = (1./(1+exp(-(-steepness*(x + x_max))))) + (1./(1+exp(-steepness*(x - x_max))));
   
   temp_y = theta_out + x_out;
   
   y = (1./(1+exp(-steepness*(temp_y - 0.5))));
end