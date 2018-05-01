% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 3, Exercise 1c
% Spring, 2018

EXERCISE_TITLE = 'Runge-Kutta Simulation for Exercise 1c';

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

% Differential equations
dVdt = @(t_n,P_n,V_n) acceleration_due_to_gravity + 0.01 * ...
  (V_n + P_n) + 0.3 * t_n^2;
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

figure('Name', EXERCISE_TITLE);
plot(t,S,'k');
hold on;
plot(t,V,'--k');

title(EXERCISE_TITLE);
xlabel('Time (seconds)');

text(3.3,14,'position','FontSize',14);
text(1.7,1,'velocity','FontSize',14);
hold off;