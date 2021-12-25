%% Input parameters
initial_time = 0;
integration_time = 10;

%% Double gyre parameters
epsilon = 0.25;
amplitude = .1;
omega = pi/5;
domain = [0,2;0,1];
resolutionX = 256;
[resolutionY,deltaX] = equal_resolution(domain,resolutionX);
resolution = [resolutionX,resolutionY];

%% Velocity definition
lDerivative = @(t,x,~)derivative(t,x,false,epsilon,amplitude,omega);
incompressible = true;

% Cauchy-Green strain
cgStrainOdeSolverOptions = odeset('relTol',1e-5);
hAxes = setup_figure(domain);

%% Cauchy-Green strain eigenvalues for forward time FTLE Field
title(hAxes,"FTLE Field at t = "+num2str(initial_time)+" for integration time-length = "+num2str(integration_time));
timespan = [initial_time initial_time+integration_time];
[~,cgEigenvalue] = eig_cgStrain(lDerivative,domain,resolution,timespan,'incompressible',incompressible,'odeSolverOptions',cgStrainOdeSolverOptions);

%% Generate forward time FTLE field values at specified initial time
maxeg = max(cgEigenvalue');
for i=1:resolutionX*resolutionY
    temp = maxeg(i);
    ftf(i) = ftle(temp,abs((timespan(2)-timespan(1))));
end
plot_ftle(hAxes,domain,resolution,ftf);

%    % Uncomment the following section and comment the correspnding previous section (lines 23-33) if backward time FTLE field is required

%    %% Cauchy-Green strain eigenvalues for backward time FTLE Field
%    integration_time = -integration_time;
%    title(hAxes,"FTLE Field at t = "+num2str(initial_time)+" for integration time-length = "+num2str(integration_time));
%    timespan = [initial_time initial_time+integration_time];
%    [~,cgEigenvalue] = eig_cgStrain(lDerivative,domain,resolution,timespan,'incompressible',incompressible,'odeSolverOptions',cgStrainOdeSolverOptions);
%
%    %% Generate forward time FTLE field values at specified initial time
%    maxeg = max(cgEigenvalue');
%    for i=1:resolutionX*resolutionY
%        temp = maxeg(i);
%        ftb(i) = ftle(temp,abs((timespan(2)-timespan(1))));
%    end
%    plot_ftle(hAxes,domain,resolution,ftb);
