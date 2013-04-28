% Copyright (c) 2013 Jonathan McCluskey
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

function xt1=model(xt,ft)
xt1=[0; 0; 0; 0];

% the paper says g=-9.8; but in Barto's program, 9.8 was used and so is here.
g  = 9.8; 

mc = 1.0; 
mp = 0.1; 
m  = mc + mp;

l   = 0.5; 
TAU = 0.02;

four3rd   = 4/3;
FORCE_MAG = -10;

d2r = pi/180;

theta=xt(1)*d2r;
theta_dot=xt(2)*d2r;
x=xt(3);
x_dot=xt(4);

% Determine the push to the cart
force=FORCE_MAG*tanh(100*ft); 

costheta=cos(theta); 
sintheta=sin(theta);
theta_dot_squared = theta_dot^2;

temp = (force + mp*l*theta_dot_squared*sintheta)/m;
thetaacc=(g*sintheta - costheta*temp)/(l*(four3rd - mp*costheta^2/m));
xacc = temp - mp*l*thetaacc*costheta/m;

% update the four states
x1=x+TAU*x_dot;
x1_dot=x_dot+TAU*xacc;
theta1=theta+TAU*theta_dot;
theta1_dot=theta_dot+TAU*thetaacc;

xt1=[theta1/d2r; theta1_dot/d2r; x1; x1_dot];
