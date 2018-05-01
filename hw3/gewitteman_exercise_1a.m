% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 3, Exercise 1a
% Spring, 2018

EXERCISE_TITLE = 'Euler Simulation for Exercise 1a';

simulation_length = 4; % seconds
deltaT = 0.25; % seconds
t = 0:deltaT:simulation_length;

% Constants
acceleration_due_to_gravity = -9.81; % m/s^2

% Initial conditions
initial_position = 11; % meters
initial_velocity = 15; % m/s

S = zeros(1,length(t));
S(1) = initial_position;

V = zeros(1,length(t));
V(1) = initial_velocity;

for i = 2:length(t)
  V(i) = V(i - 1) + acceleration_due_to_gravity * deltaT;
  S(i) = S(i - 1) + V(i - 1) * deltaT;
end

figure('Name', EXERCISE_TITLE);
plot(t,S,'k');
hold on;
plot(t,V,'--k');

title(EXERCISE_TITLE);
xlabel('Time (seconds)');

text(3.3,14,'position','FontSize',14);
text(1.6,1,'velocity','FontSize',14);
hold off;