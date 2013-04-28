function [doubleGyre,hShearAxes,hDgAxes] = double_gyre_shear_closed

doubleGyre = double_gyre;

doubleGyre.flow = set_flow_resolution(500,doubleGyre.flow);
doubleGyre.flow = set_flow_timespan([0,20],doubleGyre.flow);
doubleGyre.flow = set_flow_ode_solver_options(odeset('RelTol',1e-8,'AbsTol',1e-8),doubleGyre.flow);
doubleGyre.flow.cgStrainMethod.name = 'finiteDifference';
doubleGyre.flow.coupledIntegration = 1e4;

doubleGyre.shearline = set_shearline_resolution([10,5],doubleGyre.shearline);
doubleGyre.shearline = set_shearline_max_length(4,doubleGyre.shearline);
doubleGyre.shearline = set_shearline_average_geodesic_deviation_tol([.32,.34],doubleGyre.shearline);

%% Positive shearlines
showPlot.shearlinePos = true;
showPlot.shearlinePosFiltered = false;
showPlot.shearlineNegFiltered = false;

verbose.progress = false;

%load doubleGyre

[doubleGyre,hShearAxes] = shear_lcs_script(doubleGyre,showPlot,verbose);

poincareSection.endPosition = [.6,.55;.8,.55];
hPoincareSection = plot(hShearAxes,poincareSection.endPosition(:,1),poincareSection.endPosition(:,2));
set(hPoincareSection,'tag','poincareSection')
set(hPoincareSection,'color','k')
set(hPoincareSection,'linestyle','--')
set(hPoincareSection,'marker','o')
set(hPoincareSection,'markersize',2)
set(hPoincareSection,'MarkerFaceColor','k')
set(hPoincareSection,'MarkerEdgeColor','k')

poincareSection.numPoints = 200;

odeSolverOptions = odeset(doubleGyre.shearline.odeSolverOptions);

[closedOrbitInitialPosition,closedOrbitPosition,hPsAxes] = poincare_closed_orbit(doubleGyre.flow,doubleGyre.shearline.etaPos,poincareSection,odeSolverOptions,hShearAxes);

averageGeodesicDeviation = closed_orbit_geodesic_deviation(closedOrbitPosition,doubleGyre.flow,doubleGyre.shearline);
set(findobj(hShearAxes,'tag','closedOrbit'),'linewidth',.5)

%% Highlight closed orbit with minimum geodesic deviation
[~,idx] = min(averageGeodesicDeviation);
hPlot = plot(hShearAxes,closedOrbitPosition{idx}(:,1),closedOrbitPosition{idx}(:,2));
set(hPlot,'tag','closedOrbitMinDg')
set(hPlot,'color','r')
set(hPlot,'linewidth',1)

t = get(findobj(hPsAxes,'tag','PoincareZero'),'xdata');
hPlot = plot(hPsAxes,t(idx),0);
set(hPlot,'marker','o')
set(hPlot,'MarkerFaceColor','r')
set(hPlot,'MarkerEdgeColor','r')

%% Plot average geodesic deviation of closed orbits
hFigure = figure;
hDgAxes = axes('parent',hFigure);
set(hDgAxes,'NextPlot','add')
set(hDgAxes,'box','on')
set(hDgAxes,'xgrid','on')
set(hDgAxes,'ygrid','on')
xlabel(hDgAxes,'x')
ylabel(hDgAxes,'\langle d_g \rangle')
hPlot = plot(hDgAxes,closedOrbitInitialPosition(:,1),transpose(averageGeodesicDeviation));
set(hPlot,'marker','o')
set(hPlot,'MarkerFaceColor','b')

hPlot = plot(hDgAxes,closedOrbitInitialPosition(idx,1),averageGeodesicDeviation(idx));
set(hPlot,'marker','o')
set(hPlot,'MarkerFaceColor','r')
set(hPlot,'MarkerEdgeColor','r')

function averageGeodesicDeviation = closed_orbit_geodesic_deviation(closedOrbitPosition,flow,shearline)

x = linspace(flow.domain(1,1),flow.domain(1,2),flow.resolution(1));
y = linspace(flow.domain(2,1),flow.domain(2,2),flow.resolution(2));

dPosInterpolant = griddedInterpolant({y,x},shearline.geodesicDeviationPosMeshgrid);
geodesicDeviationPos = cellfun(@(position)dPosInterpolant(position(:,2),position(:,1)),closedOrbitPosition,'UniformOutput',false);
averageGeodesicDeviationPos = cellfun(@average_geodesic_deviation_individual,closedOrbitPosition,geodesicDeviationPos);

averageGeodesicDeviation = averageGeodesicDeviationPos;

function averageGeodesicDeviation = average_geodesic_deviation_individual(shearlinePosition,geodesicDeviation)

if size(shearlinePosition,1) == 1
    averageGeodesicDeviation = geodesicDeviation;
else
    dPosition = diff(shearlinePosition);
    arcLength = [0; cumsum(hypot(dPosition(:,1),dPosition(:,2)))];
    averageGeodesicDeviation = trapz(arcLength,geodesicDeviation)/...
        arcLength(end);
end
