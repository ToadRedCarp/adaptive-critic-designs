% Copyright (c) 2013 Jonathan McCluskey.
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

function d_NextState=dModeldx(state,action)

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

theta=state(1)*d2r;
theta_dot=state(2)*d2r;
x=state(3);
x_dot=state(4);

% Determine the push to the cart
force=FORCE_MAG*tanh(100*action); 

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

d_NextState_d_Theta=...
    [ 1, ...
      ((TAU*(d2r*g*cos(d2r*state(1)) + (d2r*sin(d2r*state(1))*(FORCE_MAG*tanh(100*action) + d2r^2*l*mp*state(2)^2*sin(d2r*state(1))))/m - (d2r^3*l*mp*state(2)^2*cos(d2r*state(1))^2)/m))/(l*(four3rd - (mp*cos(d2r*state(1))^2)/m)) - (2*TAU*d2r*mp*cos(d2r*state(1))*sin(d2r*state(1))*(g*sin(d2r*state(1)) - (cos(d2r*state(1))*(FORCE_MAG*tanh(100*action) + d2r^2*l*mp*state(2)^2*sin(d2r*state(1))))/m))/(l*m*(four3rd - (mp*cos(d2r*state(1))^2)/m)^2))/d2r, ...
      0, ...
      TAU*((d2r^3*l*mp*state(2)^2*cos(d2r*state(1)))/m - (mp*cos(d2r*state(1))*(d2r*g*cos(d2r*state(1)) + (d2r*sin(d2r*state(1))*(FORCE_MAG*tanh(100*action) + d2r^2*l*mp*state(2)^2*sin(d2r*state(1))))/m - (d2r^3*l*mp*state(2)^2*cos(d2r*state(1))^2)/m))/(m*(four3rd - (mp*cos(d2r*state(1))^2)/m)) + (d2r*mp*sin(d2r*state(1))*(g*sin(d2r*state(1)) - (cos(d2r*state(1))*(FORCE_MAG*tanh(100*action) + d2r^2*l*mp*state(2)^2*sin(d2r*state(1))))/m))/(m*(four3rd - (mp*cos(d2r*state(1))^2)/m)) + (2*d2r*mp^2*cos(d2r*state(1))^2*sin(d2r*state(1))*(g*sin(d2r*state(1)) - (cos(d2r*state(1))*(FORCE_MAG*tanh(100*action) + d2r^2*l*mp*state(2)^2*sin(d2r*state(1))))/m))/(m^2*(four3rd - (mp*cos(d2r*state(1))^2)/m)^2)) ...
    ];
    
d_NextState_d_Theta_Dot=...
    [ TAU, ...
      (d2r - (2*TAU*d2r^2*mp*state(2)*cos(d2r*state(1))*sin(d2r*state(1)))/(m*(four3rd - (mp*cos(d2r*state(1))^2)/m)))/d2r, ...
      0, ...
      TAU*((2*d2r^2*l*mp*state(2)*sin(d2r*state(1)))/m + (2*d2r^2*l*mp^2*state(2)*cos(d2r*state(1))^2*sin(d2r*state(1)))/(m^2*(four3rd - (mp*cos(d2r*state(1))^2)/m))) ...
    ];
    
d_NextState_d_X=...
    [ 0, ...
      0, ...
      1, ...
      0 ...
    ];
    
d_NextState_d_X_Dot=...
    [ 0, ...
      0, ...
      TAU, ...
      1 ...
    ];

d_NextState_d_Action=...
    [ 0, ...
      (FORCE_MAG*TAU*cos(d2r*state(1))*(100*tanh(100*action)^2 - 100))/(d2r*l*m*(four3rd - (mp*cos(d2r*state(1))^2)/m)), ...
      0, ...
      -TAU*((FORCE_MAG*(100*tanh(100*action)^2 - 100))/m + (FORCE_MAG*mp*cos(d2r*state(1))^2*(100*tanh(100*action)^2 - 100))/(m^2*(four3rd - (mp*cos(d2r*state(1))^2)/m))) ...
    ];

d_NextState=[ d_NextState_d_Theta;...
            d_NextState_d_Theta_Dot;...
            d_NextState_d_X;...
            d_NextState_d_X_Dot;...
            d_NextState_d_Action ];
