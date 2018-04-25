% Figure3_1_3.m
% Simulation of Figure 3.1.3 (pg. 62) in the textbook
% George Witteman

simulation_length = 4; % seconds
deltaT = 0.001; % seconds
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

SPEED = abs(V);

plot(t,S);
hold;
plot(t,V);
plot(t,SPEED);