clear
clc

%% Problem 1
% (a)
a = [-5 -4 -3 -2 -1 1 2 3 4 5];

% (b)
i = 1:9;

% (c)
disp(a(i));

% (d)
disp(a(2:2:10).^3);

% (e)
disp(-1 .* a(3:7));

%% Problem 2
% (b)
x = randi(25, 1, 8) - 10;
y = randi(25, 1, 8) - 10;

% (c)
% (c) i.
disp(x < y);

% (c) ii.
disp(x == y);

% (c) iii.
disp(x | y);

% (c) iv.
disp(x & (~y));

% (c) v.
disp((x > -1) & (y < 2));

% (d)
% (d) i.
disp(x(x > 4));

% (d) ii.
disp(y(x > 4));

% (d) iii.
disp(x((x < 2) | (x > 5)));

% (e)
% (e) i.
disp((x > 0) .* x);

% (e) ii.
z = x(x < 0);

% (e) iii.
disp(((rem(y,2) == 0) + 1) .* y);

%% Problem 3
sample_matrix = [-1 -2 -3; 4 5 6; -7 -8 -9; 10 -11 12];
sample_vector = [-1 2 -3 4 -5];
sample_scalar = -1;
disp(sum(sum(sample_matrix > 0, ndims(sample_matrix))));
disp(sum(sum(sample_vector > 0, ndims(sample_vector))));
disp(sum(sum(sample_scalar > 0, ndims(sample_scalar))));

%% Problem 4
% (a)
x = -5:0.01:5; 
plot(x,tanh(x));

% (b)
figure;
t = -10:0.01:10;
plot(t, 1./(1 + exp(-t)));

% (c)
% tanh and s(t) look very similar
% TODO: come back to this

% (d)
% (exp(2*x) - 1)/(exp(2*x) + 1)
% TODO: come back to this