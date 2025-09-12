% Fin_FDM_FVM.m
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
T_inf = 30;         % ambient (°C)
T_b = 100;          % base temperature (°C)

% ----------------------
% Discretization
N = 50;             % number of nodes
dx = L/(N-1);
x = linspace(0,L,N)';
m2 = h*P/(k*A);     % fin parameter

% ==========================================================
% FDM
A_fdm = zeros(N,N); b_fdm = zeros(N,1);

% Base BC
A_fdm(1,1) = 1; b_fdm(1) = T_b;

% Interior nodes
for i = 2:N-1
    A_fdm(i,i-1) = -1;
    A_fdm(i,i)   = 2 + m2*dx^2;
    A_fdm(i,i+1) = -1;
    b_fdm(i) = m2*dx^2 * T_inf;
end

% Tip (insulated: T_N = T_{N-1})
A_fdm(N,N)   = 1;
A_fdm(N,N-1) = -1;
b_fdm(N) = 0;

T_fdm = A_fdm \ b_fdm;

% ==========================================================
% FVM
A_fvm = zeros(N,N); b_fvm = zeros(N,1);
G = k*A/dx;

% Base BC
A_fvm(1,1) = 1; b_fvm(1) = T_b;

% Interior CVs
for i = 2:N-1
    Aw = G; Ae = G;
    conv_area = P*dx;
    A_fvm(i,i-1) = -Aw;
    A_fvm(i,i)   = Aw + Ae + h*conv_area;
    A_fvm(i,i+1) = -Ae;
    b_fvm(i) = h*conv_area * T_inf;
end

% Tip CV
i = N;
Aw = G; Ae = 0;
conv_area = P*(dx/2);
A_fvm(i,i-1) = -Aw;
A_fvm(i,i)   = Aw + h*conv_area;
b_fvm(i) = h*conv_area * T_inf;

T_fvm = A_fvm \ b_fvm;

% ==========================================================
% Analytical solution
m = sqrt(h*P/(k*A));
T_analytic = T_inf + (T_b - T_inf) .* ( cosh(m*(L - x)) ./ cosh(m*L) );

% ==========================================================
% Plot
figure;
plot(x, T_fdm, '-or','LineWidth',1.5); hold on;
plot(x, T_fvm, '-sb','LineWidth',1.5);
plot(x, T_analytic, '--k','LineWidth',1.6);
xlabel('x (m)'); ylabel('Temperature (°C)');
title('Steady-State Temperature Distribution in Fin');
legend('FDM','FVM','Analytical','Location','Best');
grid on;

% Error metrics
fprintf('Max |FDM - Analytical| = %.4e °C\n', max(abs(T_fdm - T_analytic)));
fprintf('Max |FVM - Analytical| = %.4e °C\n', max(abs(T_fvm - T_analytic)));
fprintf('Max |FDM - FVM|       = %.4e °C\n', max(abs(T_fdm - T_fvm)));
figure;
plot(x, T_fdm, '-or','LineWidth',1.5); hold on;
plot(x, T_fvm, '-sb','LineWidth',1.5);
xlabel('x (m)'); ylabel('Temperature (°C)');
title('Comparison of FDM and FVM Temperature Distribution');
legend('FDM','FVM','Location','Best');
grid on;

% Error metrics between FDM and FVM
MAE  = mean(abs(T_fdm - T_fvm));
RMSE = sqrt(mean((T_fdm - T_fvm).^2));
RelError = norm(T_fdm - T_fvm,2) / norm(T_fdm,2) * 100;

fprintf('Mean Absolute Error (MAE): %.4f °C\n', MAE);
fprintf('Root Mean Square Error (RMSE): %.4f °C\n', RMSE);
fprintf('Relative Error: %.4f %%\n', RelError);

% Plot comparison + error
figure;
subplot(2,1,1);
plot(x, T_fdm, '-or','LineWidth',1.5); hold on;
plot(x, T_fvm, '-sb','LineWidth',1.5);
xlabel('x (m)'); ylabel('Temperature (°C)');
title('FDM vs FVM Temperature Distribution');
legend('FDM','FVM','Location','Best'); grid on;

subplot(2,1,2);
plot(x, T_fdm - T_fvm, '-d','LineWidth',1.5);
xlabel('x (m)'); ylabel('\DeltaT (°C)');
title('Pointwise Difference (FDM - FVM)');
grid on;
