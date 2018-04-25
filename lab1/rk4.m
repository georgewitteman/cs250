% rk4.m
% Runge-Kutta 4 simulation of undampened weighted spring system (Ch. 3.2)
% George Witteman

simulation_length = 3; % seconds
deltaT = 0.02; % seconds
t = 0:deltaT:simulation_length;

init_displacement = 0.3; % meters
k = 10; % N/m (spring constant)
unweighted_length = 1; % meter
g = 9.81; % m/s^2
mass = 0.2; % kg
weight = mass * g; % (kg * m) / s^2
weight_displacement = weight / k; % (kg * N) / s^2

% Arrays
P = zeros(1,length(t));
V = zeros(1,length(t));

% Initial conditions
P(1) = unweighted_length + weight_displacement + init_displacement;
V(1) = 0;

% Differential equations
dVdt = @(t_n,P_n,V_n) ((-k * (P_n - unweighted_length)) + weight) / mass;
dPdt = @(t_n,P_n,V_n) V_n;

% Simulation Loop
for i = 2:length(t)
  dp1 = dPdt(t(i-1), P(i-1), V(i-1)) * deltaT;
  dv1 = dVdt(t(i-1), P(i-1), V(i-1)) * deltaT;
  dp2 = dPdt(t(i-1) + deltaT/2, P(i-1) + dp1/2, V(i-1) + dv1/2) * deltaT;
  dv2 = dVdt(t(i-1) + deltaT/2, P(i-1) + dp1/2, V(i-1) + dv1/2) * deltaT;
  dp3 = dPdt(t(i-1) + deltaT/2, P(i-1) + dp2/2, V(i-1) + dv2/2) * deltaT;
  dv3 = dVdt(t(i-1) + deltaT/2, P(i-1) + dp2/2, V(i-1) + dv2/2) * deltaT;
  dp4 = dPdt(t(i-1) + deltaT, P(i-1) + dp3, V(i-1) + dv3) * deltaT;
  dv4 = dVdt(t(i-1) + deltaT, P(i-1) + dp3, V(i-1) + dv3) * deltaT;
  
  P(i) = P(i-1) + (dp1 + 2*dp2 + 2*dp3 + dp4) / 6;
  V(i) = V(i-1) + (dv1 + 2*dv2 + 2*dv3 + dv4) / 6;
end

figure;
plot(t,P);
hold on;
title('Runge-Kutta 4 Simulation of Undampened Weighted Spring System');
xlabel('Time (seconds)');
ylabel('Length of spring (meters)');
hold off;