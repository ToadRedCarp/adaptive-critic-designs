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

% The Derivative of the Model (mimics the "real" plant)
% @author William Harding <wpharding1@gmail.com>
%
% @param currentState, the current state (theta, theta_dot, x, x_dot)
% @param action, the action to take
% @return the Jacobian of the derivative of the next state with respect to
% the current state and action
%
function [jacobianOfState, jacobianOfAction] = CartPoleModelScriptDerivative(currentState, action)

%% Currently this implementation returns the opposite signs as Lui's plant.
% 
% syms g
% syms m_c
% syms m
% syms l
% syms mu_c
% syms mu_p
% syms tau
% syms force
% syms action
% syms theta
% syms theta_dot
% syms theta_dot_dot
% syms x
% syms x_dot
% syms x_dot_dot

    g    = -9.8;     %m/s^2
    m_c  = 1.0;      %kg mass of cart
    m    = 0.1;      %kg mass of pole
    l    = 0.5;      %m, half-pole length
    mu_c = 0.0005;   %coefficient of friction of cart on track
    mu_p = 0.000002; %coefficient of friction of pole on cart

    tau = 0.02;      %time-step in seconds

    %%TODO
    % For some reason if force is +10 it doesn't work! Why?!
%     FORCE_LIMIT = -10;
    
    force = (exp(action) - exp(-action))/(exp(action) + exp(-action))*-10;
%     force = tansig(action)*-10;
    
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
                        mu_c*sigmoid(x_dot))/(m_c + m) ) - (mu_p*theta_dot)/(m*l) ) / ...
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
% 
%     syms next_x_dot
%     syms next_x
%     syms next_theta_dot
%     syms next_theta
%     
%     next_x_dot      = x_dot + x_dot_dot*tau;
%     next_x          = x + x_dot*tau;
%     next_theta_dot  = (theta_dot + theta_dot_dot*tau);%/degrees_to_radians;
%     next_theta      = (theta + theta_dot*tau);%/degrees_to_radians;
% 
%     diff(next_x, x)
%     diff(next_x, x_dot)
%     diff(next_x, theta)
%     diff(next_x, theta_dot)
%     
%     diff(next_x_dot, x)
%     diff(next_x_dot, x_dot)
%     diff(next_x_dot, theta)
%     diff(next_x_dot, theta_dot)
%     
%     diff(next_theta, x)
%     diff(next_theta, x_dot)
%     diff(next_theta, theta)
%     diff(next_theta, theta_dot)
%     
%     diff(next_theta_dot, x)
%     diff(next_theta_dot, x_dot)
%     diff(next_theta_dot, theta)
%     diff(next_theta_dot, theta_dot)
%     
%     
    next_x_wrt_x            = 1;
    next_x_wrt_x_dot        = tau;
    next_x_wrt_theta        = 0;
    next_x_wrt_theta_dot    = 0;   

    next_x_dot_wrt_x            = 0;
    next_x_dot_wrt_x_dot        = 1;
    next_x_dot_wrt_theta        = (l*m*tau*(theta_dot^2*cos(theta) + (cos(theta)*(g*cos(theta) + (sin(theta)*(l*m*sin(theta)*theta_dot^2 + (10*exp(-action) - 10*exp(action))/(exp(-action) + exp(action))))/(m + m_c) - (l*m*theta_dot^2*cos(theta)^2)/(m + m_c)))/(l*((m*cos(theta)^2)/(m + m_c) - 4/3)) - (sin(theta)*(g*sin(theta) - (cos(theta)*(l*m*sin(theta)*theta_dot^2 + (10*exp(-action) - 10*exp(action))/(exp(-action) + exp(action))))/(m + m_c)))/(l*((m*cos(theta)^2)/(m + m_c) - 4/3)) + (2*m*cos(theta)^2*sin(theta)*(g*sin(theta) - (cos(theta)*(l*m*sin(theta)*theta_dot^2 + (10*exp(-action) - 10*exp(action))/(exp(-action) + exp(action))))/(m + m_c)))/(l*(m + m_c)*((m*cos(theta)^2)/(m + m_c) - 4/3)^2)))/(m + m_c);
    next_x_dot_wrt_theta_dot    = (l*m*tau*(2*theta_dot*sin(theta) - (2*m*theta_dot*cos(theta)^2*sin(theta))/((m + m_c)*((m*cos(theta)^2)/(m + m_c) - 4/3))))/(m + m_c);
    
    next_theta_wrt_x            = 0;
    next_theta_wrt_x_dot        = 0;
    next_theta_wrt_theta        = 1;
    next_theta_wrt_theta_dot    = tau;

    next_theta_dot_wrt_x            = 0;
    next_theta_dot_wrt_x_dot        = 0;
    next_theta_dot_wrt_theta        = - (tau*(g*cos(theta) + (sin(theta)*(l*m*sin(theta)*theta_dot^2 + (10*exp(-action) - 10*exp(action))/(exp(-action) + exp(action))))/(m + m_c) - (l*m*theta_dot^2*cos(theta)^2)/(m + m_c)))/(l*((m*cos(theta)^2)/(m + m_c) - 4/3)) - (2*m*tau*cos(theta)*sin(theta)*(g*sin(theta) - (cos(theta)*(l*m*sin(theta)*theta_dot^2 + (10*exp(-action) - 10*exp(action))/(exp(-action) + exp(action))))/(m + m_c)))/(l*(m + m_c)*((m*cos(theta)^2)/(m + m_c) - 4/3)^2);
    next_theta_dot_wrt_theta_dot    = (2*m*tau*theta_dot*cos(theta)*sin(theta))/((m + m_c)*((m*cos(theta)^2)/(m + m_c) - 4/3)) + 1;
    
    jacobianOfState =  [next_theta_wrt_theta next_theta_wrt_theta_dot next_theta_wrt_x next_theta_wrt_x_dot; ...
                        next_theta_dot_wrt_theta next_theta_dot_wrt_theta_dot next_theta_dot_wrt_x next_theta_dot_wrt_x_dot; ...
                        next_x_wrt_theta next_x_wrt_theta_dot next_x_wrt_x next_x_wrt_x_dot; ...
                        next_x_dot_wrt_theta next_x_dot_wrt_theta_dot next_x_dot_wrt_x next_x_dot_wrt_x_dot];

%     diff(next_x, action)
%     diff(next_x_dot, action)
%     diff(next_theta, action)
%     diff(next_theta_dot, action)
                    
    next_theta_wrt_action       = 0;
    next_theta_dot_wrt_action   = (tau*cos(theta)*((10*(exp(-action) - exp(action))^2)/(exp(-action) + exp(action))^2 - 10))/(l*(m + m_c)*((m*cos(theta)^2)/(m + m_c) - 4/3));
    next_x_wrt_action           = 0;
    next_x_dot_wrt_action       = -(tau*((m*cos(theta)^2*((10*(exp(-action) - exp(action))^2)/(exp(-action) + exp(action))^2 - 10))/((m + m_c)*((m*cos(theta)^2)/(m + m_c) - 4/3)) - (10*(exp(-action) - exp(action))^2)/(exp(-action) + exp(action))^2 + 10))/(m + m_c);
    
                    
    jacobianOfAction = [next_theta_wrt_action next_theta_dot_wrt_action next_x_wrt_action next_x_dot_wrt_action];
end
            