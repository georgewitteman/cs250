% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Final Project
% Spring, 2018
simulation_length = 5 * 60; % seconds
deltaT = 1/3; % seconds (frames per second)
t = 0:deltaT:simulation_length;

% Flag to determine if we want to draw the arena. It can be much faster to
% run a simulation if we don't draw every frame
drawArena = true;

% Simulation Parameters
simParams = SimulationParameters();
simParams.ArenaWidth = 10; % ft
simParams.ArenaHeight = 10; % ft
simParams.NumBlocks = 16;
simParams.PointsHomeBlock = 3;
simParams.PointsOtherBlock = -1;
simParams.RobotWidth = 11/12; % ft
simParams.RobotHeight = 10/12; % ft
simParams.RobotSpeed = 1; % ft/sec
simParams.RotationSpeed = 35; % degrees/sec
simParams.MinSpinAngle = 90; % degrees
simParams.MaxSpinAngle = 180; % degrees
simParams.BackupTime = 1; % sec
simParams.HomeStopTime = 3 * 60; % seconds
simParams.CameraDistance = 3; % ft
simParams.CameraFOV = 115; % degrees
simParams.CameraOn = true;
simParams.TapeWidth = 2/12; % ft

arena = Arena(simParams);

% Set up the plot
f = figure;

% Set the figure window title
f.Name = 'Simulation of the Robotics Competition';
f.NumberTitle = 'off'; % No 'Figure 1' in the title bar

% Turn off the figure window menu and toolbar
f.MenuBar = 'none';
f.ToolBar = 'none';

% Set the background of the figures to be gray
set(f, 'color', [210/255 180/255 140/255]);

% Make the figure window the given size in the bottom left of the display
set(f, 'InnerPosition', [0, 0, 600, 600]);

% Re-center the figure window
movegui(f, 'center');

% Draw the initial frame at t=0
arena.draw();
setTitle(0);
drawnow;

if drawArena
  % Initialize VideoWriter to save frames to
  v = VideoWriter('save.mp4', 'MPEG-4');
  v.FrameRate = 1/deltaT;
  open(v);
end

for i = 1:length(t)
  hold off;
  
  if drawArena
    % Display this frame
    arena.draw();
    setTitle(t(i));
    drawnow
  end
  
  % Generate the next frame
  arena.nextFrame(deltaT);
  
  if drawArena
    % Get current frame;
    frame = getframe;
    
    % Save the frame in the save video
    writeVideo(v,frame);
  end
end

if drawArena
  % Close video file since we're not updating it anymore
  close(v);
end

% Always draw the last frame
arena.draw();
setTitle(simulation_length);
drawnow;

% Determine who won the simulation
disp(strcat(arena.Robot1.Color, ' points:'));
disp(arena.countPoints(arena.Robot1));

disp(strcat(arena.Robot2.Color, ' points:'));
disp(arena.countPoints(arena.Robot2));

if arena.countPoints(arena.Robot1) > arena.countPoints(arena.Robot2)
  disp(strcat(arena.Robot1.Color, ' WINS!'));
elseif arena.countPoints(arena.Robot2) > arena.countPoints(arena.Robot1)
  disp(strcat(arena.Robot2.Color, ' WINS!'));
else
  disp('TIE!');
end

function setTitle(t)
title(strcat('Simulation of Robotics Competition at t=',...
  num2str(t, '%.2f')));
end