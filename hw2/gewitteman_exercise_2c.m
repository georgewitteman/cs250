% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 2, Exercise 2a
% Spring, 2018

% Constants
simulationLength = 12; % in months
dt = 0.0001;  % Time step

ky = 1;      % Prey (Y) birth constant
kp = 1;      % Predator (P) death constant
kh = 1.5;    % Humans (H) death constant
kpy = 0.01;  % Proportion of interactions of P/Y leading to Y death
kyp = 0.01;  % Proportion of interactions of P/Y leading to P birth
khp = 0.01;  % Proportion of interactions of P/H leading to a P death
kyh = 0.03;  % Proportion of interactions of Y/H leading to a H birth
kph = 0.03;  % Proportion of interactions of P/H leading to a H birth

Y1 = 50;     % Initial size of prey
P1 = 50;     % Initial size of predators
H1 = 50;     % Initial size of humans

numIterations = simulationLength / dt;
Y = zeros(1,numIterations);  % Population size of prey
P = zeros(1,numIterations);  % Population size of predators
H = zeros(1,numIterations);  % Population size of humans

Y(1) = Y1;  % Initial size of prey
P(1) = P1;  % Initial size of predators
H(1) = H1;  % Initial size of humans

for i = 2:numIterations
  % Interactions between species
  interactYP = P(i - 1) * Y(i - 1);
  interactHY = H(i - 1) * Y(i - 1);
  interactHP = H(i - 1) * P(i - 1);

  % Difference equations (model)
  dY = (ky * Y(i - 1) - kpy * interactYP - khp * interactHY) * dt;
  dP = (- kp * P(i - 1) + kyp * interactYP - khp * interactHP) * dt;
  dH = (-kh * H(i - 1) + kyh * interactHY + kph * interactHP) * dt;

  % Populations at time i
  Y(i) = Y(i - 1) + dY;
  P(i) = P(i - 1) + dP;
  H(i) = H(i - 1) + dH;
end

% Plot
% ----
figure;  % Create new figure window
hold on; % Plot all points in the same window
plot(1:numIterations, Y);
plot(1:numIterations, P);
plot(1:numIterations, H);

title('Exercise 2c');
legend('Prey (Y)', 'Predators (P)', 'Humans (H)');
ylabel('Population');

xlabel('Months');
xticks((1:simulationLength) / dt);
xticklabels(1:simulationLength);
