% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 3, Exercise 2a
% Spring, 2018
clear; clc;
% Simulation constants
simulation_length = 3; % ms
deltaT = 0.001; % ms
t = 0:deltaT:simulation_length;

% Constants
C_m = 0.1; % capacitance (uF/cm^2)
V_K = -77; % displacement from the equilibrium potential for K+ (mV)
V_Na = 50; % displacement from the equilibrium potential for Na+ (mV)
V_L = -54.4; % displacement from the equilibrium potential for leakage (mV)
V_initial = -65; % mV

global I_start_t I_length I_value; % Allow variables to be used in functions
% Function for I is at the bottom of the file
I_start_t = 0.5; % applied current start time (ms)
I_length = 0.5; % amount of time to apply current (ms)
I_value = 15; % applied current (nA)

g_K = 36; % maximum K conductance (mS/cm^2)
g_Na = 120; % maximum Na conductance (mS/cm^2)
g_L = 0.3; % maximum leakage conductance (mS/cm^2)

c = -g_L * (V_initial - V_L); % Na-K-ATPase pump current

alpha_n = @(V_n) 0.01 * (V_n + 55) / (1 - exp(-(V_n+55)/10)); % ms^-1
alpha_m = @(V_n) 0.1 * (V_n + 40) / (1 - exp(-(V_n+40)/10)); % ms^-1
alpha_h = @(V_n) 0.07 * exp(-(V_n+65)/20); % ms^-1
beta_n = @(V_n) 0.125 * exp(-(V_n+65)/80); % ms^-1
beta_m = @(V_n) 4 * exp(-(V_n+65)/18); % ms^-1
beta_h = @(V_n) 1/(exp(-(V_n+35)/10) + 1); % ms^-1

% T = 6.3; % degrees C
% phi = 3 ^ ((T-6.3)/10); % factor for temperature correction
% alpha_n = @(V_i) phi * (0.01 * (V_i + 10) / (exp((V_i+10)/10)-1));
% alpha_m = @(V_i) phi * (0.01 * (V_i + 25) / (exp((V_i+25)/10)-1));
% alpha_h = @(V_i) phi * (0.07 * exp(V_i/20));
% beta_n = @(V_i) phi * (0.125 * exp(V_i/80));
% beta_m = @(V_i) phi * (4 * exp(V_i/18));
% beta_h = @(V_i) phi * (1/(exp((V_i + 30)/10) + 1));

% Initial conditions
V = zeros(1,length(t)); % action potential (mV)
V(1) = -65; % mV

n = zeros(1,length(t)); % potassium activation gating variable
n(1) = 0.317;

m = zeros(1,length(t)); % sodium activation gating variable
m(1) = 0.05;

h = zeros(1,length(t)); % sodium inactivation gating variable
h(1) = 0.6;

Na_inside = zeros(1,length(t)); % Na+ ion concentration inside (mM/L)
Na_inside(1) = 15; % mM/L

Na_outside = zeros(1,length(t)); % Na+ ion concentration outside (mM/L)
Na_outside(1) = 150; % mM/L

K_inside = zeros(1,length(t)); % K+ ion concentration inside (mM/L)
K_inside(1) = 150; % mM/L

K_outside = zeros(1,length(t)); % K+ ion concentration outside (mM/L)
K_outside(1) = 5.5; % mM/L

I_K = zeros(1,length(t));

PUMP = zeros(1,length(t));

% Gate and pump flags (open/closed)
Na_gate = false;
K_gate = false;
Na_K_pump = false;

for i = 1:length(t) - 1  
  % Open sodium channel
  if ~Na_gate && ~K_gate && V(i) >= -55
    disp(i);
    disp("a");
    Na_gate = true;
  end
  
  % Close sodium channel and open potassium channel
  if Na_gate && ~K_gate && V(i) >= 49.3
    disp(i);
    disp("b");
    Na_gate = false;
    K_gate = true;
  end

  I_Na_t = Na_gate *g_Na * m(i)^3 * h(i) * (V(i) - V_Na);
  I_K_t = K_gate * g_K * n(i)^4 * (V(i) - V_K);
  I_K(i) = I_K_t;
  I_L_t = g_L * (V(i) - V_L);
  
  % Na-K-ATPase Pump on/off
  c_t = 0;
  if Na_inside(i) > 0 && K_outside(i) > 0
    c_t = c;
  end
  
  PUMP(i) = c_t;
  
  dNa_outside = (I_Na_t + 3 * c_t) * deltaT;
  dK_inside = (I_K_t + I_L_t + 2 * c_t) * deltaT;

  Na_inside(i + 1) = Na_inside(i) - dNa_outside;
  Na_outside(i + 1) = Na_outside(i) + dNa_outside;
  K_inside(i + 1) = K_inside(i) + dK_inside;
  K_outside(i + 1) = K_outside(i) - dK_inside;
  
  V(i + 1) = V(i) + ((I(t(i)) - I_Na_t - I_K_t - I_L_t - c_t) ...
    / C_m) * deltaT;
  n(i + 1) = n(i) + ...
    (alpha_n(V(i)) * (1 - n(i)) - beta_n(V(i)) * n(i)) * deltaT;
  m(i + 1) = m(i) + ...
    (alpha_m(V(i)) * (1 - m(i)) - beta_m(V(i)) * m(i)) * deltaT;
  h(i + 1) = h(i) + ...
    (alpha_h(V(i)) * (1 - h(i)) - beta_h(V(i)) * h(i)) * deltaT;
  
  % Close potassium channel
  if K_gate && V(i + 1) > V(i)
    disp(i);
    disp("c");
    K_gate = false;
  end
end

PUMP(length(t)) = PUMP(length(t)-1);
I_K(length(t)) = I_K(length(t)-1);

figure();
ax1 = subplot(2,1,1); % top subplot
plot(ax1,t,V,'-k','LineWidth',1);
title('Runge-Kutta 4 Simulation of Action Potential for Exercise 2a');
xlabel('time (ms)');
ylabel('membrane potential (mV)');

ax2 = subplot(2,1,2); % bottom subplot
plot(ax2,t,n,'-k','LineWidth',1);
hold on;
plot(ax2,t,m,'--k','LineWidth',1);
plot(ax2,t,h,'-.k','LineWidth',1);
title('Runge-Kutta 4 Simulation of n, m, and h for Exercise 2a');
xlabel('time (ms)');
legend('n', 'm', 'h');
hold off;

figure()
plot(t,Na_inside,'LineWidth',1);
hold on;
plot(t,Na_outside,'LineWidth',1);
plot(t,K_inside,'LineWidth',1);
plot(t,K_outside,'LineWidth',1);
plot(t,PUMP','LineWidth',1);
title('Concentrations of Ions');
legend('Na inside', 'Na outside', 'K inside', 'K outside', 'PUMP');
hold off;

figure()
plot(t,I_K,'LineWidth',1);
hold on;
legend('I_K');
hold off;

% Function that computes the applied current in nA at a given time
function I_n = I(t_n)
  global I_start_t I_length I_value; % Use global variables
  if t_n >= I_start_t && t_n < I_start_t + I_length
    I_n = I_value;
  else
    I_n = 0;
  end
end
