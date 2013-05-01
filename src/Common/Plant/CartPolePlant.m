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


% The "real" plant
% @author William Harding <wpharding1@gmail.com>
%
% @param currentState, the current state (theta, theta_dot, x, x_dot)
% @param action, the action to take
% @return the true next state 
%
function nextState = CartPolePlant(currentState, action)

    g    = -9.8;     %m/s^2
    m_c  = 1.0;      %kg mass of cart
    m    = 0.1;      %kg mass of pole
    l    = 0.5;      %m, half-pole length
    mu_c = 0.0005;   %coefficient of friction of cart on track
    mu_p = 0.000002; %coefficient of friction of pole on cart

    tau = 0.02;      %time-step in seconds

    FORCE_LIMIT = -10;
    
    force = sign(action)*FORCE_LIMIT;
    
    friction = 0; % friction flag
    
    degrees_to_radians = pi/180;

    theta       = currentState(1);
    theta_dot   = currentState(2);
    x           = currentState(3);
    x_dot       = currentState(4);

    theta = theta * degrees_to_radians;
    theta_dot = theta_dot * degrees_to_radians;

    %theta_dot_dot %% Angular Acceleration in degrees/s^2
    %x_dot_dot     %% Acceleration in m/s^2
    if friction == 1
        theta_dot_dot = ( g*sin(theta) + cos(theta)*( (-1*force - m*l*(theta_dot^2)*sin(theta) + ...
                        mu_c*sign(x_dot))/(m_c + m) ) - (mu_p*theta_dot)/(m*l) ) / ...
                        ( l*( 4/3 - (m*(cos(theta)^2))/(m_c + m) ) );

        x_dot_dot     = (force + m*l*( (theta_dot^2)*sin(theta) - theta_dot_dot*cos(theta)) - mu_c*sigmoid(x_dot)) / ...
                        (m_c + m);

    else
        

        theta_dot_dot = (g*sin(theta) + cos(theta)*( ( -1*force - m*l*(theta_dot^2)*sin(theta) ) / ...
                        (m_c + m)) ) / ...
                        ( l*( 4/3 - (m*(cos(theta)^2))/(m_c + m) ) );

        x_dot_dot     = (force + m*l*( (theta_dot^2)*sin(theta) - theta_dot_dot*cos(theta))) / ...
                        (m_c + m);

    end

    next_x_dot      = x_dot + x_dot_dot*tau;
    next_x          = x + x_dot*tau;
    next_theta_dot  = theta_dot + theta_dot_dot*tau;
    next_theta      = theta + theta_dot*tau;

    nextState = [next_theta/degrees_to_radians; next_theta_dot/degrees_to_radians; next_x; next_x_dot];
end
            