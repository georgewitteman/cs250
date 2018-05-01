% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 3, Exercise 1d
% Spring, 2018

EXERCISE_TITLE = 'Runge-Kutta Simulation for Exercise 1d';

simulation_length = 15; % seconds
deltaT = 0.01; % seconds
t = 0:deltaT:simulation_length;

% Constants
acceleration_due_to_gravity = -9.81; % m/s^2
mass = 0.5; % kg
radius = 0.05; % meters

weight = mass * acceleration_due_to_gravity; % N
projected_area = 3.14159 * radius^2; % meters

% Initial conditions
initial_position = 400; % meters
initial_velocity = 0; % m/s

S = zeros(1,length(t));
S(1) = initial_position;

V = zeros(1,length(t));
V(1) = initial_velocity;

% Differential equations
dVdt = @(t_n,P_n,V_n) ...
  (weight + (-0.65 * projected_area * V_n * abs(V_n)))/mass;
dSdt = @(t_n,P_n,V_n) V_n;

for i = 2:length(t)
  dp1 = dSdt(t(i-1), S(i-1), V(i-1)) * deltaT;
  dv1 = dVdt(t(i-1), S(i-1), V(i-1)) * deltaT;
  dp2 = dSdt(t(i-1) + deltaT/2, S(i-1) + dp1/2, V(i-1) + dv1/2) * deltaT;
  dv2 = dVdt(t(i-1) + deltaT/2, S(i-1) + dp1/2, V(i-1) + dv1/2) * deltaT;
  dp3 = dSdt(t(i-1) + deltaT/2, S(i-1) + dp2/2, V(i-1) + dv2/2) * deltaT;
  dv3 = dVdt(t(i-1) + deltaT/2, S(i-1) + dp2/2, V(i-1) + dv2/2) * deltaT;
  dp4 = dSdt(t(i-1) + deltaT, S(i-1) + dp3, V(i-1) + dv3) * deltaT;
  dv4 = dVdt(t(i-1) + deltaT, S(i-1) + dp3, V(i-1) + dv3) * deltaT;
  
  S(i) = S(i-1) + (dp1 + 2*dp2 + 2*dp3 + dp4) / 6;
  V(i) = V(i-1) + (dv1 + 2*dv2 + 2*dv3 + dv4) / 6;
end

SPEED = abs(V);

figure('Name', EXERCISE_TITLE);
plot(t,S,'k');
hold on;
plot(t,SPEED,'--k');

title(EXERCISE_TITLE);
xlabel('Time (seconds)');

text(7.9,243,'position','FontSize', 14);
text(7.9,48,'speed','FontSize', 14);
hold off;