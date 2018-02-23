% Exercise 2
% George Witteman

% Code for 2b.
numberOfPoints = 100000;
[x,y,c] = generateRandomPoints(numberOfPoints);
estimate = getEstimate(c,numberOfPoints);
fprintf('n = %d: %.10f\n', numberOfPoints, estimate);
plotCircleEstimation(x,y,c);

% Code for 2c.
maximum = 0;
minimum = 100;
average = estimate / 1000;
for n = 2:1000
  [x,y,c] = generateRandomPoints(numberOfPoints);
  estimate = getEstimate(c, numberOfPoints);
  maximum = max(maximum, estimate);
  minimum = min(minimum, estimate);
  average = average + estimate / 1000;
end
fprintf('maximum: %f\n', maximum);
fprintf('minimum: %f\n', minimum);
fprintf('average: %f\n', average);

function [x,y,c] = generateRandomPoints(n)
% GENERATERANDOMPOINTS Generate N random X, Y, and C points.
x = rand(1,n);
y = rand(1,n);
c = sqrt(1-x.^2) > y;
end

function r = getEstimate(c, numPoints)
% GETESTIMATE Get the estimate for pi.
r = (sum(c)/numPoints) * 4;
end

function plotCircleEstimation(x,y,c)
% PLOTCIRCLEESTIMATION Plot the circle from the given X, Y, and C.
colormap([0 0 1; 1 0 0]);
scatter(x,y,10,c, 'filled')
end