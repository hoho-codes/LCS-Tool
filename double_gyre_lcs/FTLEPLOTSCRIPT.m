%% Input parameters
initial_time = 0;
integration_time = 10;

epsilon = 0.25;
amplitude = .1;
omega = pi/5;

timespan = [initial_time initial_time+integration_time];
domain = [0,2;0,1];
resolutionX = 200;
[resolutionY,deltaX] = equal_resolution(domain,resolutionX);
resolution = [resolutionX,resolutionY];

%% Velocity definition
lDerivative = @(t,x,~)derivative(t,x,false,epsilon,amplitude,omega);
incompressible = true;

%% LCS parameters
% Cauchy-Green strain
cgStrainOdeSolverOptions = odeset('relTol',1e-5);
hAxes = setup_figure(domain);
title(hAxes,"FTLE Field at t = "+num2str(initial_time)+" for integration time-length = "+num2str(integration_time));

%% Cauchy-Green strain eigenvalues and eigenvectors
[~,cgEigenvalue] = eig_cgStrain(lDerivative,domain,resolution,timespan,'incompressible',incompressible,'odeSolverOptions',cgStrainOdeSolverOptions);
maxeg = max(cgEigenvalue');
for i=1:resolutionX*resolutionY
    temp = maxeg(i);
    ftf(i) = ftle(temp,abs((timespan(2)-timespan(1))));
end
plot_ftle(hAxes,domain,resolution,ftf);