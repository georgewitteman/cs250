simulationLength = 3;
dt = 0.02;

gravitationalConstant = -9.81; % m/s^2
k = 10; % N/m (spring constant)
m = 0.2; % kg (mass of weight W)
unweightedLength = 1; % m (unweighted length of spring)
initDisplacement = 0.3; % m (init displacement of spring)
weightDisplacement = -m * gravitationalConstant;

% initial length of spring
initLength = unweightedLength + weightDisplacement + initDisplacement;