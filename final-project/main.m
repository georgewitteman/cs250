% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Final Project
% Spring, 2018
simulation_length = 5 * 60; % seconds
deltaT = 1/15; % seconds (frames per second)
t = 0:deltaT:simulation_length;

arena = Arena();

% Initialize array for our movie frames
F(length(t)) = struct('cdata',[],'colormap',[]);

% Set up the plot
f = figure;

% Set the background of the figures to be gray
set(f, 'color', [210/255 180/255 140/255]);

% Make the figure window the given size in the bottom left of the display
set(f, 'InnerPosition', [0, 0, 600, 600]);

% Re-center the figure window
movegui(f, 'center');

% Initialize VideoWriter to save frames to
v = VideoWriter('save.mp4', 'MPEG-4');
v.FrameRate = 1/deltaT;
open(v);

for i = 1:length(t)
  hold off;
  
  % Display this frame
  draw(arena);
  title(strcat('Simulation of Robotics Competition at t=',...
    num2str(t(i), '%.2f')));
  
  % Generate the next frame
  arena.nextFrame(deltaT);
  
  % Get current frame;
  frame = getframe;
  
  % Save this frame in the movie
  F(i) = frame;
  
  % Save the frame in the save video
  writeVideo(v,frame);
end

% Close video file since we're not updating it anymore
close(v);

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
