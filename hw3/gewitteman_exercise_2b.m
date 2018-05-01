% George Witteman
%
% CMPU 250: Modeling, Simulation, and Analysis
% Homework 3, Exercise 2b
% Spring, 2018

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

I_P = -g_L * (V_initial - V_L); % Na-K-ATPase pump current

alpha_n = @(V_n) 0.01 * (V_n + 55) / (1 - exp(-(V_n+55)/10)); % ms^-1
alpha_m = @(V_n) 0.1 * (V_n + 40) / (1 - exp(-(V_n+40)/10)); % ms^-1
alpha_h = @(V_n) 0.07 * exp(-(V_n+65)/20); % ms^-1
beta_n = @(V_n) 0.125 * exp(-(V_n+65)/80); % ms^-1
beta_m = @(V_n) 4 * exp(-(V_n+65)/18); % ms^-1
beta_h = @(V_n) 1/(exp(-(V_n+35)/10) + 1); % ms^-1

% Initial conditions
V = zeros(1,length(t)); % action potential (mV)
V(1) = -65; % mV

n = zeros(1,length(t)); % potassium activation gating variable
n(1) = 0.317;

m = zeros(1,length(t)); % sodium activation gating variable
m(1) = 0.05;

h = zeros(1,length(t)); % sodium inactivation gating variable
h(1) = 0.6;

% Gate flags (open/closed)
Na_gate = false;
K_gate = false;

for i = 1:length(t) - 1
  % Open sodium channel
  if ~Na_gate && ~K_gate && V(i) >= -55
    Na_gate = true;
  end
  
  % Close sodium channel and open potassium channel
  if Na_gate && ~K_gate && V(i) >= 49.3
    Na_gate = false;
    K_gate = true;
  end
  
  % Differential equations
  dI_Nadt = @(m,h,V) Na_gate * g_Na * m ^ 3 * h * (V - V_Na);
  dI_Kdt = @(n,V) K_gate * g_K * n ^ 4 * (V - V_K);
  dI_Ldt = @(V) g_L * (V - V_L);
  dI_Pdt = @(i) I_P;
  dVdt = @(t, V, n, m, h) (...
    I(t) - ... % I
    dI_Nadt(m,h,V) - ... % I_K
    dI_Kdt(n,V) - ... % I_Na
    dI_Ldt(V) - ... % I_L
    dI_Pdt(t * deltaT)) / C_m;
  dndt = @(V,n) alpha_n(V) * (1 - n) - beta_n(V) * n;
  dmdt = @(V,m) alpha_m(V) * (1 - m) - beta_m(V) * m;
  dhdt = @(V,h) alpha_h(V) * (1 - h) - beta_h(V) * h;

  dV1 = dVdt(t(i), V(i), n(i), m(i), h(i)) * deltaT;
  dn1 = dndt(V(i), n(i)) * deltaT;
  dm1 = dmdt(V(i), m(i)) * deltaT;
  dh1 = dhdt(V(i), h(i)) * deltaT;
  
  dV2 = dVdt(t(i)+deltaT/2,...
    V(i)+dV1/2, n(i)+dn1/2, m(i)+dm1/2, h(i)+dh1/2) * deltaT;
  dn2 = dndt(V(i)+dV1/2, n(i)+dn1/2) * deltaT;
  dm2 = dmdt(V(i)+dV1/2, m(i)+dm1/2) * deltaT;
  dh2 = dhdt(V(i)+dV1/2, h(i)+dh1/2) * deltaT;
  
  dV3 = dVdt(t(i)+deltaT/2,...
    V(i)+dV2/2, n(i)+dn2/2, m(i)+dm2/2, h(i)+dh2/2) * deltaT;
  dn3 = dndt(V(i)+dV2/2, n(i)+dn2/2) * deltaT;
  dm3 = dmdt(V(i)+dV2/2, m(i)+dm2/2) * deltaT;
  dh3 = dhdt(V(i)+dV2/2, h(i)+dh2/2) * deltaT;
  
  dV4 = dVdt(t(i)+deltaT,...
    V(i)+dV3, n(i)+dn3, m(i)+dm3, h(i)+dh3) * deltaT;
  dn4 = dndt(t(i)+deltaT, n(i)+dn3) * deltaT;
  dm4 = dmdt(t(i)+deltaT, m(i)+dm3) * deltaT;
  dh4 = dhdt(t(i)+deltaT, h(i)+dh3) * deltaT;
  
  V(i + 1) = V(i) + (dV1 + 2*dV2 + 2*dV3 + dV4) / 6;
  n(i + 1) = n(i) + (dn1 + 2*dn2 + 2*dn3 + dn4) / 6;
  m(i + 1) = m(i) + (dm1 + 2*dm2 + 2*dm3 + dm4) / 6;
  h(i + 1) = h(i) + (dh1 + 2*dh2 + 2*dh3 + dh4) / 6;
  
  % Close potassium channel
  if K_gate && V(i + 1) > V(i)
    K_gate = false;
  end
end

figure();
ax1 = subplot(2,1,1); % top subplot
plot(ax1,t,V,'-k','LineWidth',1);
title('Runge-Kutta 4 Simulation of Action Potential for Exercise 2b');
xlabel('time (ms)');
ylabel('membrane potential (mV)');

ax2 = subplot(2,1,2); % bottom subplot
plot(ax2,t,n,'-k','LineWidth',1);
hold on;
plot(ax2,t,m,'--k','LineWidth',1);
plot(ax2,t,h,'-.k','LineWidth',1);
title('Runge-Kutta 4 Simulation of n, m, and h for Exercise 2b');
xlabel('time (ms)');
legend('n', 'm', 'h');
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

