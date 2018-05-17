classdef Robot < handle
  %ROBOT A representation of a robot
  
  properties (Constant)
    Width  = 1 % feet
    Height = 1 % feet
  end
  
  properties
    X % horizontal center (feet)
    Y % vertical center (feet)
    R % rotation angle (degrees) (0 faces right, 90 faces up)
    Color
    Poly
  end
  
  methods
    function obj = Robot(x, y, angle, color)
      %ROBOT Construct an instance of this class
      obj.X = x;
      obj.Y = y;
      obj.R = angle;
      obj.Color = color;
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
    end
    
    function moveForward(obj, ft)
      obj.X = obj.X + ft * cos(deg2rad(obj.R));
      obj.Y = obj.Y + ft * sin(deg2rad(obj.R));
    end
    
    function rotate(obj, deg)
      obj.R = obj.R + deg;
    end
  end
end

