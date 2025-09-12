% Fin_FVM.m
clear; clc; close all;

% ----------------------
% Geometry & properties
L = 0.20;           % fin length (m)
t = 0.01;           % thickness (m)
w = 0.02;           % width (m)
A = t*w;            % cross-sectional area (m^2)
P = 2*(t + w);      % perimeter (m)

k = 205;            % thermal conductivity (W/m.K)
h = 20;             % convective coefficient (W/m^2.K)
T_inf = 30;         % ambient temperature (°C)
T_b = 100;          % base temperature (°C)

% ----------------------
% Mesh / discretization
N = 50;             % number of nodes
dx = L/(N-1);       % uniform spacing
x = linspace(0,L,N)';

% Preallocate
A_mat = zeros(N,N);
b = zeros(N,1);

% Conductance constant
G = k*A/dx;         % west/east conductance for interior faces

% ----------------------
% Base BC (Dirichlet at x=0)
A_mat(1,1) = 1;
b(1) = T_b;

% Interior CVs: i = 2 .. N-1
for i = 2:N-1
    Aw = G; Ae = G;                  % conductances to west and east
    conv_area = P * dx;              % exposed surface area for convection
    A_mat(i,i-1) = -Aw;
    A_mat(i,i)   = Aw + Ae + h*conv_area;
    A_mat(i,i+1) = -Ae;
    b(i) = h*conv_area * T_inf;
end

% Tip CV (i = N): insulated (east flux = 0)
i = N;
Aw = G; Ae = 0;
conv_area = P * (dx/2);              % half-cell convection area
A_mat(i,i-1) = -Aw;
A_mat(i,i)   = Aw + h*conv_area;
b(i) = h*conv_area * T_inf;

% ----------------------
% Solve linear system
T_fvm = A_mat \ b;

% ----------------------
% Plot
figure;
plot(x, T_fvm, '-sb','LineWidth',1.6,'MarkerFaceColor','b');
xlabel('x (m)'); ylabel('Temperature (°C)');
title('Steady-State Temperature Distribution in Fin (FVM)');
grid on;
legend('FVM','Location','Best');
