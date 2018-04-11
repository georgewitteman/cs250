% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 2, Exercise 1d
% Spring, 2018

% Constants for first simulation
simulationLength = 12; % in months
dt = 0.0001;  % Time step

ky = 2;      % Prey (Y) birth constant
kp = 1.06;   % Predator (P) birth constant
kpy = 0.02;  % Proportions of interactions of P/Y leading to prey death
kyp = 0.01;  % Proportions of interactions of P/Y leading to predator birth
fmax = 0.01; % Max value of the fishing constant

Y1 = 100;    % Initial size of prey
P1 = 15;     % Initial size of predators
H1 = 100;    % Initial size of humans

% Simulations

runSimulation('First Simulation',...
  simulationLength, dt, ky, kp, kpy, kyp, fmax, Y1, P1, H1);

runSimulation('Predator Size Close To Prey',...
  simulationLength, dt, ky, kp, kpy, kyp, fmax, Y1, 85, H1);

runSimulation('Predator Size Greater Than Prey',...
  simulationLength, dt, ky, kp, kpy, kyp, fmax, Y1, 115, H1);

function runSimulation(ttl, simulationLength,...
                       dt, ky, kp, kpy, kyp, fmax, Y1, P1, H1)
  % RUNSIMULATION Run the simulation with the given parameters
  % 
  % SIMULATIONLENGTH Number of months to simulate
  % DT Time step
  % KY Prey (Y) birth constant
  % KP Predator (P) birth constant
  % KPY Proportions of interactions of P/Y leading to prey death
  % KYP Proportions of interactions of P/Y leading to predator birth
  % FMAX Fishing constant for prey & predators (max value)
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
    % Calculate fishing constant
    t = i * dt;
    monthsPerYear = 12;
    if (mod(t, monthsPerYear) <= 6)
      % Off-season
      f = 0;
    else
      % Fishing season
      f = (fmax / 2) + (fmax / 2) * cos((2 * pi) / 6 * t + pi);
    end
        
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

  title(ttl);
  legend('Prey (Y)', 'Predators (P)', 'Humans (H)');
  ylabel('Population');
  
  xlabel('Months');
  xticks((1:simulationLength) / dt);
  xticklabels(1:simulationLength);
end
