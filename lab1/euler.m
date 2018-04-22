dt = 0.1;
simulationLength = 3;
numIterations = simulationLength / dt;

initDisplacement = 0.3; % m (initial displacement of spring)
springConstant = 10; % N/m
unweightedLength = 1; % m (unweighted length of spring)
gravitationalConstant = 9.8; % m/s^2
mass = 0.2; % kg
weight = mass * gravitationalConstant;
weightDisplacement = weight / springConstant;

length = zeros(1,numIterations);
length(1) = unweightedLength + weightDisplacement + initDisplacement;
velocity = zeros(1,numIterations);
velocity(1) = 0;

for t = 2:numIterations
  length(t) = length(t-1) + velocity(t-1) * dt;
  displacement = length(t) - unweightedLength;
  restoringForce = -springConstant * displacement;
  acceleration = weight + restoringForce / mass;
  velocity(t) = velocity(t-1) + acceleration * dt;
end

plot(1:numIterations,length);
xticks((1:simulationLength) / dt);
xticklabels(1:simulationLength);