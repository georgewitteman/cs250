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
    NumBlocks = 48;
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
          inside = x > Arena.Width/2 && y > Arena.Height/2;
        case 'green'
          inside = x < Arena.Width/2 && y > Arena.Height/2;
        case 'blue'
          inside = x > Arena.Width/2 && y < Arena.Height/2;
        case 'yellow'
          inside = x < Arena.Width/2 && y < Arena.Height/2;
      end
    end
    
    function pgon = getArenaPolyshape()
      pgon = polyshape([0 Arena.Width Arena.Width 0],...
        [0 0 Arena.Height Arena.Height]);
    end
    
    
    function drawBackground()
      % DRAWBACKGROUND Draw the background
      bg = plot(Arena.getArenaPolyshape);
      bg.FaceColor = Arena.ColorBackground;
      bg.LineStyle = 'none';
      bg.FaceAlpha = 1;
    end
    
    function drawBlueBoundary()
      blue1 = plot(...
        polyshape([0 Arena.Width/2 Arena.Width/2 0],...
        [Arena.Height/2 Arena.Height/2 ...
        Arena.Height/2+Arena.TapeWidth Arena.Height/2+Arena.TapeWidth]));
      blue1.FaceColor = Arena.ColorBlue;
      blue1.LineStyle = 'none';
      blue1.FaceAlpha = 1;
      
      blue2 = plot(...
        polyshape([Arena.Width/2-Arena.TapeWidth ...
        Arena.Width/2 Arena.Width/2 Arena.Width/2-Arena.TapeWidth],...
        [Arena.Height Arena.Height Arena.Height/2 Arena.Height/2]));
      blue2.FaceColor = Arena.ColorBlue;
      blue2.LineStyle = 'none';
      blue2.FaceAlpha = 1;
    end
    
    function drawRedBoundary()
      red1 = plot(...
        polyshape([Arena.Width/2 Arena.Width/2+Arena.TapeWidth ...
        Arena.Width/2+Arena.TapeWidth Arena.Width/2],...
        [Arena.Height Arena.Height ...
        Arena.Height/2+Arena.TapeWidth Arena.Height/2+Arena.TapeWidth]));
      red1.FaceColor = Arena.ColorRed;
      red1.LineStyle = 'none';
      red1.FaceAlpha = 1;
      
      red2 = plot(...
        polyshape([Arena.Width/2 Arena.Width Arena.Width Arena.Width/2],...
        [Arena.Height/2 Arena.Height/2 Arena.Height/2+Arena.TapeWidth ...
        Arena.Height/2+Arena.TapeWidth]));
      red2.FaceColor = Arena.ColorRed;
      red2.LineStyle = 'none';
      red2.FaceAlpha = 1;
    end
    
    function drawGreenBoundary()
      green1 = plot(...
        polyshape([Arena.Width/2 Arena.Width Arena.Width Arena.Width/2],...
        [Arena.Height/2 Arena.Height/2 Arena.Height/2-Arena.TapeWidth ...
        Arena.Height/2-Arena.TapeWidth]));
      green1.FaceColor = Arena.ColorGreen;
      green1.LineStyle = 'none';
      green1.FaceAlpha = 1;
      
      green2 = plot(...
        polyshape([Arena.Width/2 Arena.Width/2+Arena.TapeWidth ...
        Arena.Width/2+Arena.TapeWidth Arena.Width/2],...
        [Arena.Height/2 Arena.Height/2 0 0]));
      green2.FaceColor = Arena.ColorGreen;
      green2.LineStyle = 'none';
      green2.FaceAlpha = 1;
    end
    
    function drawYellowBoundary()
      yellow1 = plot(...
        polyshape([0 Arena.Width/2 Arena.Width/2 0],...
        [Arena.Height/2 Arena.Height/2 Arena.Height/2-Arena.TapeWidth ...
        Arena.Height/2-Arena.TapeWidth]));
      yellow1.FaceColor = Arena.ColorYellow;
      yellow1.LineStyle = 'none';
      yellow1.FaceAlpha = 1;
      
      yellow2 = plot(...
        polyshape([Arena.Width/2-Arena.TapeWidth Arena.Width/2 ...
        Arena.Width/2 Arena.Width/2-Arena.TapeWidth],...
        [Arena.Height/2 Arena.Height/2 0 0]));
      yellow2.FaceColor = Arena.ColorYellow;
      yellow2.LineStyle = 'none';
      yellow2.FaceAlpha = 1;
    end
    
    function drawOuterBoundary()
      outer_boundary_l = plot(...
        polyshape([0 Arena.TapeWidth Arena.TapeWidth 0], ...
        [0 0 Arena.Height Arena.Height]));
      outer_boundary_l.FaceColor = 'white';
      outer_boundary_l.LineStyle = 'none';
      outer_boundary_l.FaceAlpha = 1;
      
      outer_boundary_t = plot(...
        polyshape([0 Arena.Width Arena.Width 0], ...
        [Arena.Height Arena.Height Arena.Height-Arena.TapeWidth ...
        Arena.Height-Arena.TapeWidth]));
      outer_boundary_t.FaceColor = 'white';
      outer_boundary_t.LineStyle = 'none';
      outer_boundary_t.FaceAlpha = 1;
      
      outer_boundary_r = plot(...
        polyshape([Arena.Width Arena.Width Arena.Width-Arena.TapeWidth ...
        Arena.Width-Arena.TapeWidth], [0 Arena.Height Arena.Height 0]));
      outer_boundary_r.FaceColor = 'white';
      outer_boundary_r.LineStyle = 'none';
      outer_boundary_r.FaceAlpha = 1;
      
      outer_boundary_b = plot(...
        polyshape([0 Arena.Width Arena.Width 0],...
        [0 0 Arena.TapeWidth Arena.TapeWidth]));
      outer_boundary_b.FaceColor = 'white';
      outer_boundary_b.LineStyle = 'none';
      outer_boundary_b.FaceAlpha = 1;
    end
    
    function inQ = isFullyInQuadrant(x,y,w,h,R,quad)
      %ISFULLYINQUADRANT
      % Determines if the given rectangle is fully in the quadrant
      
      % Get the bounding points of the quadrant
      if strcmp(quad,'green')
        x_min = Arena.Width/2;
        x_max = Arena.Width;
        y_min = 0;
        y_max = Arena.Height/2;
      elseif strcmp(quad,'red')
        x_min = Arena.Width/2;
        x_max = Arena.Width;
        y_min = Arena.Height/2;
        y_max = Arena.Height;
      elseif strcmp(quad,'blue')
        x_min = 0;
        x_max = Arena.Width/2;
        y_min = Arena.Height/2;
        y_max = Arena.Height;
      elseif strcmp(quad,'yellow')
        x_min = 0;
        x_max = Arena.Width/2;
        y_min = 0;
        y_max = Arena.Height/2;
      end
      
      % Get the polyshape defined by arguments
      polyout = getPolyshape(x, y, w, h, R);
      
      % Get the polyshape that represents the quadrants bounds
      bounds = polyshape([x_min x_max x_max x_min],...
        [y_min y_min y_max y_max]);
      
      % Get the boundary vertices of the input rectangle
      [x,y] = boundary(polyout);
      
      % Input rectangle is in the quadrant if all of its vertices are
      % within the bounds of the quadrant
      inQ = all(isinterior(bounds, x, y));
    end
    
    function inB = inBounds(x, y, width, height, R)
      %INBOUNDS
      % Check if the given rectangle is in the arena bounds delineated by
      % the white lines
      
      % Get the polyshape defined by arguments
      polyout = getPolyshape(x, y, width, height, R);
      
      % Get the polyshape representing the area in bounds
      bounds = polyshape([0 Arena.Width Arena.Width 0],...
        [0 0 Arena.Height Arena.Height]);
      
      % Get boundary vertices of the input shape
      [x,y] = boundary(polyout);
      
      % Input shape is in bounds if all of its vertices are within the
      % bounds
      inB = all(isinterior(bounds, x, y));
    end
    
  end
  
  methods
    function obj = Arena()
      %ARENA Construct an instance of this class
      obj.Robot1 = Robot(Arena.Width/4, Arena.Height/4,...
        rad2deg(atan(Arena.Height/Arena.Width)), 'yellow');
      obj.Robot2 = Robot(3*(Arena.Width/4), 3*(Arena.Height/4),...
        180+rad2deg(atan(Arena.Height/Arena.Width)), 'red');
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
      bounds = Arena.getArenaPolyshape();
      if overlaps(obj.Robot1.getPoly(), polyout)
        available = false;
      elseif overlaps(obj.Robot2.getPoly(), polyout)
        available = false;
      elseif ~overlaps(bounds, polyout)
        available = false;
      else
        available = true;
      end
    end
    
    function [x,y] = getRandomQuadrantPoint(obj, quad)
      if strcmp(quad,'green')
        x_min = Arena.Width/2;
        x_max = Arena.Width;
        y_min = 0;
        y_max = Arena.Height/2;
      elseif strcmp(quad,'red')
        x_min = Arena.Width/2;
        x_max = Arena.Width;
        y_min = Arena.Height/2;
        y_max = Arena.Height;
      elseif strcmp(quad,'blue')
        x_min = 0;
        x_max = Arena.Width/2;
        y_min = Arena.Height/2;
        y_max = Arena.Height;
      elseif strcmp(quad,'yellow')
        x_min = 0;
        x_max = Arena.Width/2;
        y_min = 0;
        y_max = Arena.Height/2;
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
    
    function hit = robotsHit(obj)
      hit = overlaps(obj.Robot1.getPoly(), obj.Robot2.getPoly());
    end
    
    function nextFrame(obj, deltaT)
      obj.Robot1.nextFrame(obj, deltaT);
      obj.Robot2.nextFrame(obj, deltaT);
      
      % Collect blocks into robots
      for i = 1:length(obj.Blocks) - 1
        x = obj.Blocks(i).X;
        y = obj.Blocks(i).Y;
        
        % Collect the block for Robot 1 if appropriate
        if isinterior(obj.Robot1.getPoly(),x,y) && ...
            strcmp(obj.Robot1.Color, obj.Blocks(i).Color)
          obj.Robot1.BlockCount = obj.Robot1.BlockCount + 1;
          obj.Blocks(i) = [];
        elseif isinterior(obj.Robot2.getPoly(),x,y) && ...
            strcmp(obj.Robot2.Color, obj.Blocks(i).Color)
          obj.Robot2.BlockCount = obj.Robot2.BlockCount + 1;
          obj.Blocks(i) = [];
        end
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
      
      % Set the aspect ratio of the plot box
      pbaspect([1 1 1]);
           
      % Turn off axis labels
      axis off;
      
      % Force drawing
      drawnow;
    end
  end
end

