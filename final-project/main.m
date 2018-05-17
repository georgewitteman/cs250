% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Final Project
% Spring, 2018
simulation_length = 5; % seconds
deltaT = 0.03333333333; % seconds
t = 0:deltaT:simulation_length;

arena = Arena();

% Initialize array for our movie frames
F(length(t)) = struct('cdata',[],'colormap',[]);

% Set up the plot
f = figure;

% Set the background of the figures to be gray
set(f,'color',[210/255 180/255 140/255]);

% Make the figure window 550px by 550px in the bottom left of the display
set(f, 'InnerPosition', [0, 0, 550, 550]);

% Re-center the figure window
movegui(f, 'center');

% Display initial frame
draw(arena);

display(Arena.currentQuadrant(arena.Robot2));

% Initialize VideoWriter to save frames to
v = VideoWriter('save.mp4', 'MPEG-4');
v.FrameRate = 1/deltaT;
open(v);

% for i = 1:length(t)
%   hold off;
% 
%   % Display this frame
%   show(arena);
%   
%   % Get current frame;
%   frame = getframe;
%   
%   % Save this frame in the movie
%   F(i) = frame;
%   
%   % Save the frame in the save video
%   writeVideo(v,frame);
% end

% Close video file since we're not updating it anymore
close(v);

% Replay the movie 2 times
% movie(F,2);




