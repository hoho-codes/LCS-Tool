 

%% Input parameters
epsilon = 0.25;
amplitude = .1;
omega = pi/5;
domain = [0,2;0,1];
resolutionX = 512; %set smaller value if smaller '.mat' file is required
[resolutionY,deltaX] = equal_resolution(domain,resolutionX);
resolution = [resolutionX,resolutionY];

%% Velocity definition
lDerivative = @(t,x,~)derivative(t,x,false,epsilon,amplitude,omega);
incompressible = true;

%% LCS parameters
% Cauchy-Green strain
cgStrainOdeSolverOptions = odeset('relTol',1e-5);


%% Cauchy-Green strain eigenvalues and eigenvectors

ftleValuesf=double.empty;
ftleValuesb=double.empty;

for j=0:100
    
    timespan = [j*0.1,10+j*0.1];
    [~,cgEigenvalue] = eig_cgStrain(lDerivative,domain,resolution,timespan,'incompressible',incompressible,'odeSolverOptions',cgStrainOdeSolverOptions);
    maxeg = max(cgEigenvalue');
    for i=1:resolutionX*resolutionY
        temp = maxeg(i);
        ft(i) = ftle(temp,abs(abs(timespan(2)-timespan(1))));
    end
    ftleValuesf = [ftleValuesf;ft];
    timespan = [j*0.1,-10+j*0.1];
    [~,cgEigenvalue] = eig_cgStrain(lDerivative,domain,resolution,timespan,'incompressible',incompressible,'odeSolverOptions',cgStrainOdeSolverOptions);
    maxeg = max(cgEigenvalue');
    for i=1:resolutionX*resolutionY
        temp = maxeg(i);
        ft(i) = ftle(temp,abs(abs(timespan(2)-timespan(1))));
    end
    ftleValuesb = [ftleValuesb;ft];

end
save('double_gyre_ftle_values_0to10s.mat','ftleValuesf','ftleValuesb','resolution');
