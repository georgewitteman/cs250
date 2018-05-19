% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Final Project
% Spring, 2018
simulation_length = 5 * 60; % seconds
deltaT = 1/60; % seconds (frames per second)
t = 0:deltaT:simulation_length;

% Flag to determine if we want to draw the arena
drawArena = true;

arena = Arena();

if drawArena
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
end

for i = 1:length(t)
  hold off;
  
  if drawArena
    % Display this frame
    draw(arena);
    title(strcat('Simulation of Robotics Competition at t=',...
      num2str(t(i), '%.2f')));
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
