classdef Arena < handle
  %ARENA A representation of an arena for the robotics competition
  
  properties (Constant)
    Width  = 10 % feet
    Height = 10 % feet
    TapeWidth = 2/12 % inches
    ColorBackground = [0.5 0.5 0.5];
    ColorRed = [252/255 13/255 27/255];
    ColorGreen = [41/255 253/255 47/255];
    ColorBlue = [47/255 214/255 254/255];
    ColorYellow = [255/255 253/255 56/255];
    NumBlocks = 16;
  end
  
  properties
    Robot1
    Robot2
    Blocks
  end
  
  methods(Static)
    function quad = currentQuadrant(obj)
      if Arena.inQuadrant(obj.X, obj.Y, 'green')
        quad = 'green';
      elseif Arena.inQuadrant(obj.X, obj.Y, 'blue')
        quad = 'blue';
      elseif Arena.inQuadrant(obj.X, obj.Y, 'red')
        quad = 'red';
      else
        quad = 'yellow';
      end
    end
    
    function inside = inQuadrant(x, y, quadrant)
      switch quadrant
        case 'red'
          inside = x > 5 && y > 5;
        case 'green'
          inside = x < 5 && y > 5;
        case 'blue'
          inside = x > 5 && y < 5;
        case 'yellow'
          inside = x < 5 && y < 5;
      end
    end
    
    function drawBackground()
      % DRAWBACKGROUND Draw the background
      bg = plot(polyshape([0 10 10 0], [0 0 10 10]));
      bg.FaceColor = Arena.ColorBackground;
      bg.LineStyle = 'none';
      bg.FaceAlpha = 1;
    end
    
    function drawBlueBoundary()
      blue1 = plot(...
        polyshape([0 5 5 0],...
        [5 5 5+Arena.TapeWidth 5+Arena.TapeWidth]));
      blue1.FaceColor = Arena.ColorBlue;
      blue1.LineStyle = 'none';
      blue1.FaceAlpha = 1;
      
      blue2 = plot(...
        polyshape([5-Arena.TapeWidth 5 5 5-Arena.TapeWidth],...
        [10 10 5 5]));
      blue2.FaceColor = Arena.ColorBlue;
      blue2.LineStyle = 'none';
      blue2.FaceAlpha = 1;
    end
    
    function drawRedBoundary()
      red1 = plot(...
        polyshape([5 5+Arena.TapeWidth 5+Arena.TapeWidth 5],...
        [10 10 5+Arena.TapeWidth 5+Arena.TapeWidth]));
      red1.FaceColor = Arena.ColorRed;
      red1.LineStyle = 'none';
      red1.FaceAlpha = 1;
      
      red2 = plot(...
        polyshape([5 10 10 5],...
        [5 5 5+Arena.TapeWidth 5+Arena.TapeWidth]));
      red2.FaceColor = Arena.ColorRed;
      red2.LineStyle = 'none';
      red2.FaceAlpha = 1;
    end
    
    function drawGreenBoundary()
      green1 = plot(...
        polyshape([5 10 10 5],...
        [5 5 5-Arena.TapeWidth 5-Arena.TapeWidth]));
      green1.FaceColor = Arena.ColorGreen;
      green1.LineStyle = 'none';
      green1.FaceAlpha = 1;
      
      green2 = plot(...
        polyshape([5 5+Arena.TapeWidth 5+Arena.TapeWidth 5],...
        [5 5 0 0]));
      green2.FaceColor = Arena.ColorGreen;
      green2.LineStyle = 'none';
      green2.FaceAlpha = 1;
    end
    
    function drawYellowBoundary()
      yellow1 = plot(...
        polyshape([0 5 5 0],...
        [5 5 5-Arena.TapeWidth 5-Arena.TapeWidth]));
      yellow1.FaceColor = Arena.ColorYellow;
      yellow1.LineStyle = 'none';
      yellow1.FaceAlpha = 1;
      
      yellow2 = plot(...
        polyshape([5-Arena.TapeWidth 5 5 5-Arena.TapeWidth],...
        [5 5 0 0]));
      yellow2.FaceColor = Arena.ColorYellow;
      yellow2.LineStyle = 'none';
      yellow2.FaceAlpha = 1;
    end
    
    function drawOuterBoundary()
      outer_boundary_l = plot(...
        polyshape([0 Arena.TapeWidth Arena.TapeWidth 0], [0 0 10 10]));
      outer_boundary_l.FaceColor = 'white';
      outer_boundary_l.LineStyle = 'none';
      outer_boundary_l.FaceAlpha = 1;
      
      outer_boundary_t = plot(...
        polyshape([0 10 10 0], [10 10 10-Arena.TapeWidth 10-Arena.TapeWidth]));
      outer_boundary_t.FaceColor = 'white';
      outer_boundary_t.LineStyle = 'none';
      outer_boundary_t.FaceAlpha = 1;
      
      outer_boundary_r = plot(...
        polyshape([10 10 10-Arena.TapeWidth 10-Arena.TapeWidth], [0 10 10 0]));
      outer_boundary_r.FaceColor = 'white';
      outer_boundary_r.LineStyle = 'none';
      outer_boundary_r.FaceAlpha = 1;
      
      outer_boundary_b = plot(...
        polyshape([0 10 10 0], [0 0 Arena.TapeWidth Arena.TapeWidth]));
      outer_boundary_b.FaceColor = 'white';
      outer_boundary_b.LineStyle = 'none';
      outer_boundary_b.FaceAlpha = 1;
    end
  end
  
  methods
    function obj = Arena()
      %ARENA Construct an instance of this class
      obj.Robot1 = Robot(2.5, 2.5, 45, 'yellow');
      obj.Robot2 = Robot(7.5, 7.5, -135, 'red');
      obj.Blocks = Block.empty();
      obj.initializeBlocks();
    end
    
    function initializeBlocks(obj)
      for i = 1:obj.NumBlocks
        if mod(i,4) == 0
          quad = 'blue';
        elseif mod(i,4) == 1
          quad = 'red';
        elseif mod(i,4) == 2
          quad = 'yellow';
        elseif mod(i,4) == 3
          quad = 'green';
        end
        
        if i <= obj.NumBlocks/4
          color = 'blue';
        elseif i <= obj.NumBlocks/4*2
          color = 'red';
        elseif i <= obj.NumBlocks/4*3
          color = 'yellow';
        else
          color = 'green';
        end
        
        [x,y] = obj.getRandomQuadrantPoint(quad);
        obj.Blocks(i) = Block(x,y,color);
      end
    end
    
    function available = spaceAvailable(obj, x, y, width, height, R)
      %SPACEAVAILABLE
      % Determine whether the given space already has something placed
      % there
      polyout = getPolyshape(x, y, width, height, R);
      if overlaps(obj.Robot1.getPoly(), polyout)
        available = false;
      elseif overlaps(obj.Robot2.getPoly(), polyout)
        available = false;
      else
        available = true;
      end
    end
    
    function [x,y] = getRandomQuadrantPoint(obj, quad)
      if strcmp(quad,'green')
        x_min = 5;
        x_max = 10;
        y_min = 0;
        y_max = 5;
      elseif strcmp(quad,'red')
        x_min = 5;
        x_max = 10;
        y_min = 5;
        y_max = 10;
      elseif strcmp(quad,'blue')
        x_min = 0;
        x_max = 5;
        y_min = 5;
        y_max = 10;
      elseif strcmp(quad,'yellow')
        x_min = 0;
        x_max = 5;
        y_min = 0;
        y_max = 5;
      end
      
      x = (x_max-x_min).*rand(1,1) + x_min;
      y = (y_max-y_min).*rand(1,1) + y_min;
      if ~obj.spaceAvailable(x,y, Block.Width, Block.Height, 0)
        [x,y] = obj.getRandomQuadrantPoint(quad);
      end
    end
    
    function drawBlocks(obj)
      %DRAWBLOCKS Draw blocks on the arena
      
      for i = 1:length(obj.Blocks)
        obj.Blocks(i).draw();
      end
    end
    
    function draw(obj)
      %SHOW Draw a map of the arena
      
      % Reset figure
      hold off;
      
      % Draw background
      Arena.drawBackground();
      
      % Hold all next plots on the graph
      hold on
      
      % Draw boundarys
      Arena.drawRedBoundary();
      Arena.drawGreenBoundary();
      Arena.drawBlueBoundary();
      Arena.drawYellowBoundary();
      Arena.drawOuterBoundary();
      
      % Draw all the blocks
      for i = 1:length(obj.Blocks)
        obj.Blocks(i).draw();
      end
      
      % Draw each robot
      draw(obj.Robot1);
      draw(obj.Robot2);
      
      % Set the axis min and max
      axis([0 obj.Width 0 obj.Height]);
      
      % Turn off axis labels
      axis off;
      
      % Force drawing
      drawnow;
    end
  end
end

