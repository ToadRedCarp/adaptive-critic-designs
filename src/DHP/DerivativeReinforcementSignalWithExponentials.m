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

% The Derivative of the Reinforcement Signal (i.e. how's the cart and pole really doing?)
% @author William Harding <wpharding1@gmail.com>
%
% @param theta, the angle of the pole
% @param x, the position of the cart
% @return the gradient of the reinforcement signal with respect to theta
% and x)
%
function deriv=DerivativeReinforcementSignalWithExponentials(theta, x)   
   theta_max = 12;
   x_max     = 2.4;
   x_exponent = 2;
   theta_exponent = 2;
   c_1 = 5;
   c_2 = 150;
%    
%    syms theta
%    syms x
%    syms x_exponent
%    syms theta_exponent
%    syms c_1
%    syms c_2
%    
%    y = (c_1*theta^theta_exponent + c_2*x^x_exponent);
%    
   deriv(1) = c_1*theta^(theta_exponent - 1)*theta_exponent;
   deriv(2) = c_2*x^(x_exponent - 1)*x_exponent;
end