classdef Robot < handle
  %ROBOT A representation of a robot
  
  properties (Constant)
    Width  = 1 % feet
    Height = 1 % feet
    Speed  = 1 % feet/second
    RotationSpeed = 35 % degrees/second
  end
  
  properties
    X % horizontal center (feet)
    Y % vertical center (feet)
    R % rotation angle (degrees) (0 faces right, 90 faces up)
    Color
    State_Drive
    State_Spin
    State_Backup
    StateTime
    BlockCount
    SpinDir
  end
  
  methods(Static)
    function dir = pickDir()
      %PICKDIR Pick a random direction (-1: left, 1: right)
%       if randMinMax(-1,1) >= 0
%         dir = 1;
%       else
%         dir = -1;
%       end
      dir = 1;
    end
  end
  
  methods
    function obj = Robot(x, y, angle, color)
      %ROBOT Construct an instance of this class
      obj.X = x;
      obj.Y = y;
      obj.R = angle;
      obj.Color = color;
      obj.State_Drive = true;
      obj.State_Spin = false;
      obj.State_Backup = false;
      obj.BlockCount = 0;
      obj.SpinDir = -1;
    end
    
    function setPosition(obj, x, y)
      obj.X = x;
      obj.Y = y;
    end
    
    function polyout = getPoly(obj)
      %GETPOLY Generate a POLYSHAPE for the given robot
      
      polyout = getPolyshape(obj.X, obj.Y, obj.Width, obj.Height, obj.R);
    end
    
    function pgon_arrow = getPGonArrow(obj)
      %GETPGONARROW Generate a POLYSHAPE for robots inner arrow
      
      [x1,x2,x3,x4,y1,y2,y3,y4] = ...
        squareVertices(obj.X, obj.Y, obj.Width, obj.Height);
      
      % Generate the shape and transform it
      pgon_arrow = polyshape([x1 ((x2+x3)/2) x4], [y1 ((y2+y3)/2) y4]);
      pgon_arrow = rotate(pgon_arrow, obj.R, [obj.X obj.Y]);
      pgon_arrow = scale(pgon_arrow, 0.25, [obj.X obj.Y]);
    end
    
    function draw(obj)
      %SHOW Draw the robot on the current figure
      
      % Plot polygon
      plot(obj.getPoly(), 'FaceAlpha', 1, 'FaceColor', obj.Color);
      hold on;
      
      % Plot the center as an arrow
      plot(obj.getPGonArrow(), 'FaceAlpha', 1,...
        'FaceColor', [0.3 0.3 0.3], 'LineStyle', 'none');
      
      % Draw the robot's blocks on top of the bot
      for i = 1:obj.BlockCount
        b = Block(obj.X,obj.Y,'red');
        pgon = b.getPolyshape();
        % Translate the block to a good position in the front of the robot
        polyout = translate(pgon, [0.3 (i-2.5)*0.15]);
        % Rotate the block in accordance with the robot
        polyout = rotate(polyout, obj.R, [obj.X obj.Y]);
        p = plot(polyout);
        p.FaceAlpha = 1;
        p.FaceColor = obj.Color;
        p.EdgeColor = 'black';
        p.LineWidth = 0.5;
      end
    end
    
    function b = canMoveForward(obj, ft, arena)
      [x,y] = obj.getNextPosition(ft);
      b = arena.inBounds(x, y, obj.Width, obj.Height, obj.R);
    end
    
    function b = inBounds(obj, arena)
      b = arena.inBounds(obj.X, obj.Y, obj.Width, obj.Height, obj.R);
    end
    
    function [x,y] = getNextPosition(obj, ft)
      x = obj.X + ft * cos(deg2rad(obj.R));
      y = obj.Y + ft * sin(deg2rad(obj.R));
    end
    
    function moveForward(obj, ft)
      [x,y] = obj.getNextPosition(ft);
      obj.X = x;
      obj.Y = y;
    end
    
    function rotate(obj, deg)
      obj.R = obj.R + deg;
    end
    
    function drive(obj, arena, deltaT)
      if obj.inBounds(arena) && ~arena.robotsHit()
        obj.moveForward(obj.Speed*deltaT);
      else
        obj.State_Drive = false;
        obj.State_Spin = true;
        obj.State_Backup = true;
        obj.StateTime = 1;
      end
    end

    function backup(obj, arena, deltaT)
      if obj.StateTime <= 0 && obj.State_Spin
        % Get out of the backup state
        obj.State_Backup = false;
        % Pick a random direction to spin
        obj.SpinDir = Robot.pickDir();
        % Spin between 90 and 180 degrees
        obj.StateTime = randMinMax(90/obj.RotationSpeed,...
          180/obj.RotationSpeed);
      elseif obj.StateTime <= 0
        obj.State_Backup = false;
      else 
        if obj.canMoveForward(-obj.Speed*deltaT, arena)
          obj.moveForward(-obj.Speed*deltaT);
        end
      end
    end
    
    function spin(obj, ~, deltaT)
      if obj.StateTime <= 0
        obj.State_Spin = false;
        obj.State_Drive = true;
      else
        obj.rotate(obj.SpinDir * obj.RotationSpeed * deltaT);
      end
    end
    
    function nextFrame(obj, arena, deltaT)
      if obj.State_Drive
        obj.drive(arena, deltaT);
      elseif obj.State_Spin && obj.State_Backup
        obj.backup(arena, deltaT);
      elseif obj.State_Spin
        obj.spin(arena, deltaT);
      end
      obj.StateTime = obj.StateTime - deltaT;
    end
  end
end

