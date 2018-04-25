% euler.m
% Euler simulation of undampened weighted spring system (Ch. 3.2)
% George Witteman

simulation_length = 3; % seconds
deltaT = 0.02; % seconds
t = 0:deltaT:simulation_length;

init_displacement = 0.3; % meters
spring_constant = 10; % N/m (spring constant)
unweighted_length = 1; % meter
acceleration_due_to_gravity = 9.81; % m/s^2
mass = 0.2; % kg
weight = mass * acceleration_due_to_gravity; % (kg * m) / s^2
weight_displacement = weight / spring_constant; % (kg * N) / s^2

% Arrays
P = zeros(1,length(t)); % position / spring length
V = zeros(1,length(t)); % velocity

% Initial conditions
P(1) = unweighted_length + weight_displacement + init_displacement;
V(1) = 0;

% Simulation Loop
for i = 2:length(t)
  P(i) = P(i-1) + V(i-1) * deltaT;
  displacement = P(i) - unweighted_length;
  restoring_spring_force = -spring_constant * displacement;
  dVdt = (weight + restoring_spring_force) / mass;
  V(i) = V(i-1) + dVdt * deltaT;
end

figure;
plot(t,P);
hold on;
title('Euler Simulation of Undampened Weighted Spring System');
xlabel('Time (seconds)');
ylabel('Length of spring (meters)');
hold off;