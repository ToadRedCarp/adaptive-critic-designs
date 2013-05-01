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


% The Cart-Pole Graphical User Interface
% @author William Harding <wpharding1@gmail.com>

classdef CartPoleGUI < handle
    properties (GetAccess=private)
        fig
        guiAxes
        
        poleLength
        cartWidth
        cartHeight
        
        LEFT_LINE
        RIGHT_LINE
        TOP_LINE
        BOT_LINE
        POLE_LINE
        
        ANGLE_DISPLAY
    end
    
    methods
        
        %Constructor
        function obj = CartPoleGUI(theta, x) 
            obj.fig = figure;
            obj.guiAxes = axes;
            
            set(obj.guiAxes, 'Visible', 'off');
            %# Stretch the axes over the whole figure.
            set(obj.guiAxes, 'Position', [0, 0, 1, 1]);
            %# Switch off autoscaling.
            set(obj.guiAxes, 'Xlim', [-2.4, 2.4], 'YLim', [0, 1.2]);
            
            obj.poleLength = 1;
            obj.cartWidth  = 0.6;
            obj.cartHeight = 0.1;
            
            thetaRad = theta * pi/180;

            obj.LEFT_LINE    = line([x - obj.cartWidth/2, x - obj.cartWidth/2], [0, obj.cartHeight], 'Parent', obj.guiAxes);
            obj.RIGHT_LINE   = line([x + obj.cartWidth/2, x + obj.cartWidth/2], [0, obj.cartHeight], 'Parent', obj.guiAxes);
            obj.TOP_LINE     = line([x - obj.cartWidth/2, x + obj.cartWidth/2], [obj.cartHeight, obj.cartHeight], 'Parent', obj.guiAxes);
            obj.BOT_LINE     = line([x - obj.cartWidth/2, x + obj.cartWidth/2], [0, 0], 'Parent', obj.guiAxes);
            obj.POLE_LINE    = line([x, x + obj.poleLength*cos(thetaRad)], [obj.cartHeight, (obj.cartHeight + obj.poleLength)*sin(thetaRad)], 'Parent', obj.guiAxes);
        end
        
        %% update
        % theta - angle in degrees (where straight up is 90 degrees)
        % x     - location between of the center of the cart
        function update(obj, theta, x)
            
            delete(obj.POLE_LINE);
            delete(obj.LEFT_LINE);
            delete(obj.RIGHT_LINE);
            delete(obj.TOP_LINE);
            delete(obj.BOT_LINE);
            delete(obj.ANGLE_DISPLAY);
            
            thetaRad = theta * pi/180;
            obj.LEFT_LINE    = line([x - obj.cartWidth/2, x - obj.cartWidth/2], [0, obj.cartHeight], 'Parent', obj.guiAxes);
            obj.RIGHT_LINE   = line([x + obj.cartWidth/2, x + obj.cartWidth/2], [0, obj.cartHeight], 'Parent', obj.guiAxes);
            obj.TOP_LINE     = line([x - obj.cartWidth/2, x + obj.cartWidth/2], [obj.cartHeight, obj.cartHeight], 'Parent', obj.guiAxes);
            obj.BOT_LINE     = line([x - obj.cartWidth/2, x + obj.cartWidth/2], [0, 0], 'Parent', obj.guiAxes);
            obj.POLE_LINE    = line([x, x + obj.poleLength*cos(thetaRad)], [obj.cartHeight, (obj.cartHeight + obj.poleLength)*sin(thetaRad)], 'Parent', obj.guiAxes);
            
            
            obj.ANGLE_DISPLAY = uicontrol('Parent', obj.fig, 'Style', 'edit', 'String', -1*theta + 90);
%             uicontrol('Parent', obj.fig, 'Style', 'edit', 'String', x, 'Position', [0.9 0.2 0.1 0.1]);
            
            pause(0.0001)
        end
        
    end
end
        