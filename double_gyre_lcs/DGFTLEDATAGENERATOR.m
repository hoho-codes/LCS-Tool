%% Script to generate '.mat' file storing FTLE Field values at 100 timeshots from 0 to 10 seconds at 0.1s intervals 
end_time = 10
time_shot_interval = 0.1

% Double gyre parameters
epsilon = 0.25;
amplitude = .1;
omega = pi/5;
domain = [0,2;0,1];
resolutionX = 512; %set smaller value if smaller '.mat' file is required
[resolutionY,deltaX] = equal_resolution(domain,resolutionX);
resolution = [resolutionX,resolutionY];

% Velocity definition
lDerivative = @(t,x,~)derivative(t,x,false,epsilon,amplitude,omega);
incompressible = true;

% Cauchy-Green strain
cgStrainOdeSolverOptions = odeset('relTol',1e-5);

ftleValuesf=double.empty;
ftleValuesb=double.empty;
for j=0:endtime*time_shot_interval
    
    % Cauchy-Green strain eigenvalues for forward time FTLE field
    timespan = [j*time_shot_interval,end_time+j*time_shot_interval];
    [~,cgEigenvalue] = eig_cgStrain(lDerivative,domain,resolution,timespan,'incompressible',incompressible,'odeSolverOptions',cgStrainOdeSolverOptions);
    
    % Generate forward time FTLE field values at specified initial time
    maxeg = max(cgEigenvalue');
    for i=1:resolutionX*resolutionY
        temp = maxeg(i);
        ft(i) = ftle(temp,abs(abs(timespan(2)-timespan(1))));
    end
    ftleValuesf = [ftleValuesf;ft];
    
    % Cauchy-Green strain eigenvalues for backward time FTLE field
    timespan = [j*time_shot_interval,-end_time+j*time_shot_interval];
    [~,cgEigenvalue] = eig_cgStrain(lDerivative,domain,resolution,timespan,'incompressible',incompressible,'odeSolverOptions',cgStrainOdeSolverOptions);
    
    % Generate backward time FTLE field values at specified initial time
    maxeg = max(cgEigenvalue');
    for i=1:resolutionX*resolutionY
        temp = maxeg(i);
        ft(i) = ftle(temp,abs(abs(timespan(2)-timespan(1))));
    end
    ftleValuesb = [ftleValuesb;ft];

end
save('double_gyre_ftle_values_0to10s.mat','ftleValuesf','ftleValuesb','resolution');
