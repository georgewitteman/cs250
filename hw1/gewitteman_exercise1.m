% Exercise 1
% George Witteman
t = 0:10:18000;
y = radium266Decay(t);
plot(t, y)

function Q = radium266Decay(t)
% RADIUM266DECAY Computes the exponential decay of radium-266.
%   Q = RADIUM266DECAY(T) computes Q for given time T as a fraction of the
%   initial quantity

Q = exp(-0.000427869 * t);
end