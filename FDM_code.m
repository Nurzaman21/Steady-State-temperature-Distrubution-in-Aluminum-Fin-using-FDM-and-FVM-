% Fin_FDM.m
clear; clc; close all;

% ----------------------
% Geometry & properties
L = 0.20;           % fin length (m)
t = 0.01;           % thickness (m)
w = 0.02;           % width (m)
A = t*w;            % cross-sectional area (m^2)
P = 2*(t + w);      % perimeter (m)

k = 205;            % thermal conductivity (W/mK) ~ Al
h = 20;             % convective coefficient (W/m2K)
T_inf = 30;         % ambient temperature (degC)
T_b = 100;          % base temperature (degC)

% ----------------------
% Discretization
N = 50;             % number of nodes
dx = L/(N-1);
x = linspace(0,L,N)';
m2 = h*P/(k*A);     % fin parameter

% ----------------------
% Coefficient matrix and RHS
A_mat = zeros(N,N);
b = zeros(N,1);

% Base BC: Dirichlet
A_mat(1,1) = 1;
b(1) = T_b;

% Interior nodes
for i = 2:N-1
    A_mat(i,i-1) = -1;
    A_mat(i,i)   = 2 + m2*dx^2;
    A_mat(i,i+1) = -1;
    b(i) = m2*dx^2 * T_inf;
end

% Tip BC: insulated -> T_N = T_{N-1}
A_mat(N,N)   = 1;
A_mat(N,N-1) = -1;
b(N) = 0;

% ----------------------
% Solve
T = A_mat\b;

% ----------------------
% Plot
figure;
plot(x,T,'-or','LineWidth',1.6);
xlabel('x (m)'); ylabel('Temperature (°C)');
title('Steady-State Temperature Distribution in Fin (FDM)');
grid on;
