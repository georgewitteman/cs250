% Exercise 1
% George Witteman

% Question 1a.
t = 0:10:18000;
y = radium266Decay(t);
plot(t, y)

% Question 1b.
disp(radium266Decay(500));
disp(radium266Decay(5000));

function Q = radium266Decay(t)
% RADIUM266DECAY Computes the exponential decay of radium-266.
%   Q = RADIUM266DECAY(T) computes Q for given time T as a fraction of the
%   initial quantity

decayRate = -0.000427869;
Q = exp(decayRate * t);
end