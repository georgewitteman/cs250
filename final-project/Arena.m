classdef Arena < handle
  %ARENA A representation of an arena for the robotics competition

  properties
    Robot1
    Robot2
    Blocks
    Width
    Height
    TapeWidth
    NumBlocks
    PointsHomeBlock
    PointsOtherBlock
    ColorBackground
    ColorRed
    ColorGreen
    ColorBlue
    ColorYellow
  end
  
  methods
    function obj = Arena(simParams)
      %ARENA Construct an instance of this class
      obj.Width = simParams.ArenaWidth;
      obj.Height = simParams.ArenaHeight;
      obj.TapeWidth = simParams.TapeWidth;
      obj.NumBlocks = simParams.NumBlocks;
      obj.PointsHomeBlock = simParams.PointsHomeBlock;
      obj.PointsOtherBlock = simParams.PointsOtherBlock;
      obj.ColorBackground = [0.5 0.5 0.5];
      obj.ColorRed = [252/255 13/255 27/255];
      obj.ColorGreen = [41/255 253/255 47/255];
      obj.ColorBlue = [47/255 214/255 254/255];
      obj.ColorYellow = [255/255 253/255 56/255];
      
      w = simParams.ArenaWidth;
      h = simParams.ArenaHeight;
      obj.Robot1 = Robot(simParams ,w/4, h/4,...
        rad2deg(atan(h/w)), 'yellow');
      obj.Robot2 = Robot(simParams, 3*(w/4), 3*(h/4),...
        180+rad2deg(atan(h/w)), 'red');
      obj.Blocks = Block.empty();
      obj.initializeBlocks();
    end
    
    function quad = currentQuadrant(obj, robot)
      if obj.inQuadrant(robot.X, robot.Y, 'green')
        quad = 'green';
      elseif obj.inQuadrant(robot.X, robot.Y, 'blue')
        quad = 'blue';
      elseif obj.inQuadrant(robot.X, robot.Y, 'red')
        quad = 'red';
      else
        quad = 'yellow';
      end
    end
    
    function inside = inQuadrant(obj, x, y, quadrant)
      switch quadrant
        case 'red'
          inside = x > obj.Width/2 && y > obj.Height/2;
        case 'green'
          inside = x < obj.Width/2 && y > obj.Height/2;
        case 'blue'
          inside = x > obj.Width/2 && y < obj.Height/2;
        case 'yellow'
          inside = x < obj.Width/2 && y < obj.Height/2;
      end
    end
    
    function pgon = getArenaPolyshape(obj)
      pgon = polyshape([0 obj.Width obj.Width 0],...
        [0 0 obj.Height obj.Height]);
    end
    
    function drawBackground(obj)
      % DRAWBACKGROUND Draw the background
      bg = plot(obj.getArenaPolyshape);
      bg.FaceColor = obj.ColorBackground;
      bg.LineStyle = 'none';
      bg.FaceAlpha = 1;
    end
    
    function drawBlueBoundary(obj)
      blue1 = plot(...
        polyshape([0 obj.Width/2 obj.Width/2 0],...
        [obj.Height/2 obj.Height/2 ...
        obj.Height/2+obj.TapeWidth obj.Height/2+obj.TapeWidth]));
      blue1.FaceColor = obj.ColorBlue;
      blue1.LineStyle = 'none';
      blue1.FaceAlpha = 1;
      
      blue2 = plot(...
        polyshape([obj.Width/2-obj.TapeWidth ...
        obj.Width/2 obj.Width/2 obj.Width/2-obj.TapeWidth],...
        [obj.Height obj.Height obj.Height/2 obj.Height/2]));
      blue2.FaceColor = obj.ColorBlue;
      blue2.LineStyle = 'none';
      blue2.FaceAlpha = 1;
    end
    
    function drawRedBoundary(obj)
      red1 = plot(...
        polyshape([obj.Width/2 obj.Width/2+obj.TapeWidth ...
        obj.Width/2+obj.TapeWidth obj.Width/2],...
        [obj.Height obj.Height ...
        obj.Height/2+obj.TapeWidth obj.Height/2+obj.TapeWidth]));
      red1.FaceColor = obj.ColorRed;
      red1.LineStyle = 'none';
      red1.FaceAlpha = 1;
      
      red2 = plot(...
        polyshape([obj.Width/2 obj.Width obj.Width obj.Width/2],...
        [obj.Height/2 obj.Height/2 obj.Height/2+obj.TapeWidth ...
        obj.Height/2+obj.TapeWidth]));
      red2.FaceColor = obj.ColorRed;
      red2.LineStyle = 'none';
      red2.FaceAlpha = 1;
    end
    
    function drawGreenBoundary(obj)
      green1 = plot(...
        polyshape([obj.Width/2 obj.Width obj.Width obj.Width/2],...
        [obj.Height/2 obj.Height/2 obj.Height/2-obj.TapeWidth ...
        obj.Height/2-obj.TapeWidth]));
      green1.FaceColor = obj.ColorGreen;
      green1.LineStyle = 'none';
      green1.FaceAlpha = 1;
      
      green2 = plot(...
        polyshape([obj.Width/2 obj.Width/2+obj.TapeWidth ...
        obj.Width/2+obj.TapeWidth obj.Width/2],...
        [obj.Height/2 obj.Height/2 0 0]));
      green2.FaceColor = obj.ColorGreen;
      green2.LineStyle = 'none';
      green2.FaceAlpha = 1;
    end
    
    function drawYellowBoundary(obj)
      yellow1 = plot(...
        polyshape([0 obj.Width/2 obj.Width/2 0],...
        [obj.Height/2 obj.Height/2 obj.Height/2-obj.TapeWidth ...
        obj.Height/2-obj.TapeWidth]));
      yellow1.FaceColor = obj.ColorYellow;
      yellow1.LineStyle = 'none';
      yellow1.FaceAlpha = 1;
      
      yellow2 = plot(...
        polyshape([obj.Width/2-obj.TapeWidth obj.Width/2 ...
        obj.Width/2 obj.Width/2-obj.TapeWidth],...
        [obj.Height/2 obj.Height/2 0 0]));
      yellow2.FaceColor = obj.ColorYellow;
      yellow2.LineStyle = 'none';
      yellow2.FaceAlpha = 1;
    end
    
    function drawOuterBoundary(obj)
      outer_boundary_l = plot(...
        polyshape([0 obj.TapeWidth obj.TapeWidth 0], ...
        [0 0 obj.Height obj.Height]));
      outer_boundary_l.FaceColor = 'white';
      outer_boundary_l.LineStyle = 'none';
      outer_boundary_l.FaceAlpha = 1;
      
      outer_boundary_t = plot(...
        polyshape([0 obj.Width obj.Width 0], ...
        [obj.Height obj.Height obj.Height-obj.TapeWidth ...
        obj.Height-obj.TapeWidth]));
      outer_boundary_t.FaceColor = 'white';
      outer_boundary_t.LineStyle = 'none';
      outer_boundary_t.FaceAlpha = 1;
      
      outer_boundary_r = plot(...
        polyshape([obj.Width obj.Width obj.Width-obj.TapeWidth ...
        obj.Width-obj.TapeWidth], [0 obj.Height obj.Height 0]));
      outer_boundary_r.FaceColor = 'white';
      outer_boundary_r.LineStyle = 'none';
      outer_boundary_r.FaceAlpha = 1;
      
      outer_boundary_b = plot(...
        polyshape([0 obj.Width obj.Width 0],...
        [0 0 obj.TapeWidth obj.TapeWidth]));
      outer_boundary_b.FaceColor = 'white';
      outer_boundary_b.LineStyle = 'none';
      outer_boundary_b.FaceAlpha = 1;
    end
    
    function inQ = isFullyInQuadrant(obj, x,y,w,h,R,quad)
      %ISFULLYINQUADRANT
      % Determines if the given rectangle is fully in the quadrant
      
      % Get the bounding points of the quadrant
      if strcmp(quad,'green')
        x_min = obj.Width/2;
        x_max = obj.Width;
        y_min = 0;
        y_max = obj.Height/2;
      elseif strcmp(quad,'red')
        x_min = obj.Width/2;
        x_max = obj.Width;
        y_min = obj.Height/2;
        y_max = obj.Height;
      elseif strcmp(quad,'blue')
        x_min = 0;
        x_max = obj.Width/2;
        y_min = obj.Height/2;
        y_max = obj.Height;
      elseif strcmp(quad,'yellow')
        x_min = 0;
        x_max = obj.Width/2;
        y_min = 0;
        y_max = obj.Height/2;
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
    
    function inB = inBounds(obj, x, y, width, height, R)
      %INBOUNDS
      % Check if the given rectangle is in the arena bounds delineated by
      % the white lines
      
      % Get the polyshape defined by arguments
      polyout = getPolyshape(x, y, width, height, R);
      
      % Get the polyshape representing the area in bounds
      bounds = polyshape([0 obj.Width obj.Width 0],...
        [0 0 obj.Height obj.Height]);
      
      % Get boundary vertices of the input shape
      [x,y] = boundary(polyout);
      
      % Input shape is in bounds if all of its vertices are within the
      % bounds
      inB = all(isinterior(bounds, x, y));
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
          color = 'green';
        elseif i <= obj.NumBlocks/4*2
          color = 'blue';
        elseif i <= obj.NumBlocks/4*3
          color = 'yellow';
        else
          color = 'red';
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
      bounds = obj.getArenaPolyshape();
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
    
    function TF = insideOuterBoundary(obj,x,y,width,height,R)
      %INSIDEOUTERBOUNDARY Determine whether the given rectangle is fully
      %inside the boundary lines (i.e. not on the white line)
      
      % Get the input rectangle
      polyout = getPolyshape(x,y,width,height,R);
      
      % Get the bounds of the arena inside the white lines
      tw = obj.TapeWidth;
      w = obj.Width;
      h = obj.Height;      
      bounds = polyshape([tw w-tw w-tw tw], [tw tw h-tw h-tw]);
      
      % Get the boundary vertices of the input rectangle
      [x,y] = boundary(polyout);
      
      % Input rectangle is in the quadrant if all of its vertices are
      % within the bounds of the quadrant
      TF = all(isinterior(bounds, x, y));
    end
    
    function [x,y] = getRandomQuadrantPoint(obj, quad)
      if strcmp(quad,'green')
        x_min = obj.Width/2;
        x_max = obj.Width;
        y_min = 0;
        y_max = obj.Height/2;
      elseif strcmp(quad,'red')
        x_min = obj.Width/2;
        x_max = obj.Width;
        y_min = obj.Height/2;
        y_max = obj.Height;
      elseif strcmp(quad,'blue')
        x_min = 0;
        x_max = obj.Width/2;
        y_min = obj.Height/2;
        y_max = obj.Height;
      elseif strcmp(quad,'yellow')
        x_min = 0;
        x_max = obj.Width/2;
        y_min = 0;
        y_max = obj.Height/2;
      end
      
      x = (x_max-x_min).*rand(1,1) + x_min;
      y = (y_max-y_min).*rand(1,1) + y_min;
      if ~obj.spaceAvailable(x, y, Block.Width, Block.Height, 0) ||...
          ~obj.insideOuterBoundary(x, y, Block.Width, Block.Height, 0)
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
    
    function c = countPoints(obj, robot)
      %COUNTPOINTS Compute the number of points ROBOT receives
      c = 0;
      
      % Count the uncaught blocks in ROBOTs home quadrant
      for i = 1:length(obj.Blocks)
        if obj.inQuadrant(obj.Blocks(i).X, obj.Blocks(i).Y, robot.Color)
          if strcmp(obj.Blocks(i).Color, robot.Color)
            c = c + obj.PointsHomeBlock;
          else
            c = c + obj.PointsOtherBlock;
          end
        end
      end
      
      % Include the caught blocks if ROBOT is in it's home quadrant
      if obj.inQuadrant(robot.X, robot.Y, robot.Color)
        c = c + (robot.BlockCount * obj.PointsHomeBlock);
      end
    end
    
    function nextFrame(obj, deltaT)
      obj.Robot1.nextFrame(obj, deltaT);
      obj.Robot2.nextFrame(obj, deltaT);
      
      % Collect blocks into robots
      for i = length(obj.Blocks):-1:1
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
      obj.drawBackground();
      
      % Hold all next plots on the graph
      hold on
      
      % Draw boundarys
      obj.drawRedBoundary();
      obj.drawGreenBoundary();
      obj.drawBlueBoundary();
      obj.drawYellowBoundary();
      obj.drawOuterBoundary();
      
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
      
      % Center the plot box in the middle of the figure window
      set(gca, 'Position', [0.05 0.05 0.9 0.9])
      
      % Turn off axis labels
      axis off;
      
      % Force drawing
      drawnow;
    end
  end
end

