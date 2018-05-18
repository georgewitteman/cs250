classdef Robot < handle
  %ROBOT A representation of a robot
  
  properties (Constant)
    Width  = 11/12 % feet
    Height = 10/12 % feet
    Speed  = 1 % feet/second
    
    % The speed that the robot is able to rotate at
    RotationSpeed = 35 % degrees/second
    
    % Min and max angles (in degrees) that the robot will spin after it's
    % hit another robot or a wall
    MinSpinAngle = 90 % degrees
    MaxSpinAngle = 180 % degrees
    
    % Time that the robot should back up after it's hit a wall
    BackupTime = 1 % second
    
    % When this time has been reached the robot will always stop if it's
    % fully in it's home quadrant
    HomeStopTime = 3 * 60 % seconds
    
    % Camera parameters
    CameraDistance = 5 % feet
    CameraFOV = 135 % degrees
  end
  
  properties
    % Position
    X % horizontal center (feet)
    Y % vertical center (feet)
    R % rotation angle (degrees) (0 faces right, 90 faces up)
    
    % Robot's color
    Color
    
    % State flags
    State_Drive
    State_Spin
    State_Backup
    
    % Timer (in seconds) to keep track of how long we've been in certain
    % states
    StateTime
    
    % Number of blocks we've captured
    BlockCount
    
    % Direction we're currently spinning in
    SpinDir
    
    % Seconds that we've been running
    RunTime
    
    % Camera for this robot
    Camera
  end
  
  methods(Static)
    function dir = pickDir()
      %PICKDIR Pick a direction for the robot to spin in (-1:left, 1:right)
      dir = 1;
      %       if randMinMax(-1,1) >= 0
      %         dir = 1;
      %       else
      %         dir = -1;
      %       end
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
      obj.RunTime = 0;
      obj.Camera = Camera(obj.CameraDistance, obj.CameraFOV, color);
    end
    
    function setPosition(obj, x, y)
      %SETPOSITION Set the position of the robot at (X,Y)
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
      
      % Plot the camera
      [x_cam,y_cam] = obj.getCameraPosition();
      obj.Camera.draw(x_cam, y_cam, obj.R);
      
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
    
    function [x,y] = getCameraPosition(obj)
      %GETCAMERAPOSITION Get the (x,y) coordinates of the camera
      x = obj.Height/2 * cos(deg2rad(obj.R)) + obj.X;
      y = obj.Height/2 * sin(deg2rad(obj.R)) + obj.Y;
    end
    
    function b = canMoveForward(obj, ft, arena)
      %CANMOVEFORWARD Determine if the robot can move forward
      [x,y] = obj.getNextPosition(ft);
      b = arena.inBounds(x, y, obj.Width, obj.Height, obj.R);
    end
    
    function b = inBounds(obj, arena)
      %INBOUNDS Determine if the robot is in the bounds of the arena
      b = arena.inBounds(obj.X, obj.Y, obj.Width, obj.Height, obj.R);
    end
    
    function [x,y] = getNextPosition(obj, ft)
      %GETNEXTPOSITION Get the next position the robot will be in
      x = obj.X + ft * cos(deg2rad(obj.R));
      y = obj.Y + ft * sin(deg2rad(obj.R));
    end
    
    function moveForward(obj, ft)
      %MOVEFORWARD Move the robot FT feet forward
      [x,y] = obj.getNextPosition(ft);
      obj.X = x;
      obj.Y = y;
    end
    
    function rotate(obj, deg)
      %ROTATE Rotate the robot DEG degrees
      obj.R = obj.R + deg;
    end
    
    function stop = endGame(obj, arena)
      %ENDGAME Determine if the robot should stop moving
      
      % The robot should stop driving when it's fully in it's home quadrant
      % and either it has all it's blocks or has reached HOMESTOPTIME
      stop = (obj.RunTime >= obj.HomeStopTime || obj.BlockCount >= 4) &&...
        obj.isInHomeQuadrant(arena);
    end
    
    function inHome = isInHomeQuadrant(obj, arena)
      %ISINHOMEQUADRANT Determine if the robot is in it's home quadrant
      inHome = arena.isFullyInQuadrant(obj.X, obj.Y, obj.Width,...
        obj.Height, obj.R, obj.Color);
    end
    
    function TF = hasBlocksInFOV(obj, arena)
      %HASBLOCKSINFOV Determine if the robot has any blocks in it's FOV
      TF = ~isempty(obj.getBlocksInFOV(arena));
    end
    
    function res = getBlocksInFOV(obj, arena)
      %GETBLOCKSINFOV Get a list of the blocks in the robot's FOV
      [x_cam, y_cam] = obj.getCameraPosition();
      blocks = arena.Blocks;
      camera = obj.Camera;
      res = Block.empty();
      for i = 1:length(blocks)
        b = blocks(i);
        if camera.inFieldOfView(x_cam, y_cam, obj.R, b.X, b.Y) &&...
            strcmp(b.Color, obj.Color)
          res(length(res) + 1) = b;
        end
      end
    end
    
    function drive(obj, arena, deltaT)
      %DRIVE Drive the robot forward
      
      blocksInFOV = obj.getBlocksInFOV(arena);
      
      if obj.endGame(arena)
        % Do nothing... nowhere else for this robot to go
        
      elseif ~isempty(blocksInFOV) && obj.inBounds(arena) &&...
          ~arena.robotsHit()
        % There are blocks in the field of view
        
        closestBlock = blocksInFOV(1);
        for i = 1:length(blocksInFOV)
          b = blocksInFOV(i);
          if pdist([obj.X,obj.Y;b.X,b.Y]) < ...
              pdist([obj.X,obj.Y;closestBlock.X,closestBlock.Y])
            closestBlock = b;
          end
        end
        
        [x_cam, y_cam] = obj.getCameraPosition();
        offCenter = obj.Camera.getAngleOffCenter(x_cam, y_cam, obj.R,...
          closestBlock.X, closestBlock.Y);

        % Steer towards the block
        obj.rotate(obj.RotationSpeed * deltaT *...
          (sqrt(abs(offCenter)) / sqrt(obj.Camera.ViewAngle/2)) *...
          (offCenter / abs(offCenter)));
        obj.moveForward(obj.Speed*deltaT);
        
      elseif obj.inBounds(arena) && ~arena.robotsHit()
        % Robot is in bounds and hasn't hit another robot
        
        obj.moveForward(obj.Speed*deltaT);
        
      else
        % Robot hit a boundary or another robot
        
        obj.State_Drive = false;
        obj.State_Spin = true;
        obj.State_Backup = true;
        obj.StateTime = obj.BackupTime;
      end
    end
    
    function backup(obj, arena, deltaT)
      %BACKUP Backup the robot
      if obj.StateTime <= 0 && obj.State_Spin
        % Get out of the backup state
        obj.State_Backup = false;
        % Pick a random direction to spin
        obj.SpinDir = Robot.pickDir();
        % Spin between 90 and 180 degrees
        obj.StateTime = randMinMax(...
          obj.MinSpinAngle/obj.RotationSpeed,...
          obj.MaxSpinAngle/obj.RotationSpeed);
      elseif obj.StateTime <= 0
        obj.State_Backup = false;
      else
        if obj.canMoveForward(-obj.Speed*deltaT, arena)
          obj.moveForward(-obj.Speed*deltaT);
        end
      end
    end
    
    function spin(obj, ~, deltaT)
      %SPIN Spin the robot
      if obj.StateTime <= 0
        obj.State_Spin = false;
        obj.State_Drive = true;
      else
        obj.rotate(obj.SpinDir * obj.RotationSpeed * deltaT);
      end
    end
    
    function nextFrame(obj, arena, deltaT)
      %NEXTFRAME Get the next frame of this robot
      if obj.State_Drive
        obj.drive(arena, deltaT);
      elseif obj.State_Spin && obj.State_Backup
        obj.backup(arena, deltaT);
      elseif obj.State_Spin
        obj.spin(arena, deltaT);
      end
      obj.StateTime = obj.StateTime - deltaT;
      obj.RunTime = obj.RunTime + deltaT;
    end
  end
end

