% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 2, Exercise 1b and 1c
% Spring, 2018

% Constants for first simulation without fishing
% Values for the constants based on the example from textbook
simulationLength = 12; % in months
dt = 0.00001;  % Time step

ky = 2;      % Prey (Y) birth constant
kp = 1.06;   % Predator (P) death constant
kpy = 0.02;  % Proportions of interactions of P/Y leading to prey death
kyp = 0.01;  % Proportions of interactions of P/Y leading to predator birth
f = 0;       % Fishing constant

Y1 = 100;    % Initial size of prey
P1 = 15;     % Initial size of predators
H1 = 100;    % Initial size of humans

runSimulation('First Simulation',...
  simulationLength, dt, ky, kp, kpy, kyp, f, Y1, P1, H1)

% Additional simulations without fishing
% --------------------------------------
% Initial predator population (90) close to prey population (100)
runSimulation('P = 90 close to Y = 100',...
  simulationLength, dt, ky, kp, kpy, kyp, f, 100, 90, H1)

% Initial predator population (100) is greater than initial prey
% population (15)
runSimulation('P = 100 > Y = 15',...
  simulationLength, dt, ky, kp, kpy, kyp, f, 15, 100, H1)

% Additional simulations with fishing
% -----------------------------------
% Fishing constant = 0.005
runSimulation('Fishing constant = 0.005',...
  simulationLength, dt, ky, kp, kpy, kyp, 0.005, Y1, P1, H1)

% Fishing constant = 0.01
runSimulation('Fishing constant = 0.01',...
  simulationLength, dt, ky, kp, kpy, kyp, 0.01, Y1, P1, H1)

% Fishing constant = 0.015
runSimulation('Fishing constant = 0.015',...
  simulationLength, dt, ky, kp, kpy, kyp, 0.015, Y1, P1, H1)

% Simulations for Exercise 1b
% ---------------------------
runSimulation('Fishing constant = 0.0175',...
  simulationLength, dt, ky, kp, kpy, kyp, 0.0175, Y1, P1, H1)

runSimulation('Fishing constant = 0.019',...
  simulationLength, dt, ky, kp, kpy, kyp, 0.019, Y1, P1, H1)

runSimulation('Fishing constant = 0.02',...
  simulationLength, dt, ky, kp, kpy, kyp, 0.02, Y1, P1, H1)

runSimulation('Fishing constant = 0.03',...
  simulationLength, dt, ky, kp, kpy, kyp, 0.2, Y1, P1, 10)

function runSimulation(t, simulationLength,...
                       dt, ky, kp, kpy, kyp, f, Y1, P1, H1)
  % RUNSIMULATION Run the simulation with the given parameters
  % 
  % SIMULATIONLENGTH Number of months to simulate
  % DT Time step
  % KY Prey (Y) birth constant
  % KP Predator (P) death constant
  % KPY Proportions of interactions of P/Y leading to prey death
  % KYP Proportions of interactions of P/Y leading to predator birth
  % F Fishing constant for prey & predators
  % Y1 Initial size of prey
  % P1 Initial size of predators
  % H1 Initial size of humans
  
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
    dY = (ky * Y(i - 1) - kpy * interactYP - f * interactHY) * dt;
    dP = (- kp * P(i - 1) + kyp * interactYP - f * interactHP) * dt;
    dH = 0;

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
  
  title(t);
  legend('Prey (Y)', 'Predators (P)', 'Humans (H)');
  ylabel('Population');
  
  xlabel('Months');
  xticks((1:simulationLength) / dt);
  xticklabels(1:simulationLength);
end
