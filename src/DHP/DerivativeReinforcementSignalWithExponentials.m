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
   
%    syms theta_max
%    syms x_max
%    syms y
%    syms x
%    syms theta
   
%    y = (theta^2 + x^5)/(theta_max^2 + x_max^5);
   
    deriv(1) = (5*x^4)/(5*x_max^4);
    deriv(2) = (2*theta)/(2*theta_max);
%    deriv(1) = (2*theta)/(theta_max^2 + x_max^5);
%    deriv(2) = (5*x^4)/(theta_max^2 + x_max^5);
end