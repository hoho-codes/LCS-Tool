
%% Script to plot how the velocity and vorticity fields change over time alongwith the evolution of some particles.
%% To generate a movie file comment out lines 23,24,90,91,92,95

% Grid to plot velocity and vorticity of the Double Gyre
N = 15;
x=linspace(0,2,N);
y=linspace(0,1,N);
[xg,yg] = meshgrid(x,y);

% Location of Initial Points
xi = 0.8;yi = 0;
xf = 1.4;yf = 0.4;
n = 10;
dx=(xf-xi)/(n-1);
dy=(yf-yi)/(n-1);

% Double Gyre Parameters
A = 0.1;
w = pi/5;
eps = 0.25;

% mov = VideoWriter('Double Gyre Flow Vorticity with Particles 20s.avi');
% mov.FrameRate = 10;

% Length of the movie in 0.1s. Default value set is 2 minutes.
endtime = 1200;

% Using the DoubleGyreDerivative.m function to define a derivative function
% to use for particle trajectory integration
derivative = @(t,x,~)DoubleGyreDerivative(t,x,eps,w,A);
for i = 0:endtime

    t=i*0.1;
    
    % Evaluating the function f of Double Gyre along with its first and
    % second derivatives
    f = (eps*sin(w*t))*xg.^2+(1-2*eps*sin(w*t)).*xg;
    dfdx = (2*eps*sin(w*t)).*xg+(1-2*eps*sin(w*t));
    d2fdx2 = (2*eps*sin(w*t));
    
    % Velocity values given by differentiating the stream function of Double Gyre
    u=-A*pi*(sin(pi*f)).*(cos(pi*yg));
    v=A*pi*(sin(pi*yg)).*(cos(pi*f)).*dfdx;
    
    % Vorticity value given by taking the grad^2 of the stream function
    vort = A*pi*sin(pi*yg).*(-pi*sin(pi*f).*(dfdx.^2)+cos(pi*f)*d2fdx2-pi*sin(pi*f));

    % Plotting the vorticity using a pseudocolor plot and velocity using
    % arrows to represent the vectors
    pcolor(x,y,vort);title(["Velocity and Vorticity","Time (in seconds): "+num2str(t)]);
    shading interp;colorbar;hold on;
    quiver(xg,yg,u,v,'m');
    xlim([0 2]);ylim([0 1]);

    % Plotting particles as time increases
    if(i==0)
        % Initial positons of particles excluding section between x = 1.12
        % and x = 1.14
        for p=0:n-1
            for q=0:n-1
                if (xi+p*dx>1.14)
                    scatter(xi+p*dx,yi+q*dy,'o','filled','k');
                elseif (xi+p*dx<1.12)
                    scatter(xi+p*dx,yi+q*dy,'o','filled','w');
                end
            end
        end
    else
        % Time evolution of particles excluding section between x = 1.12
        % and x = 1.14
        for p=0:n-1
            for q=0:n-1
                if (xi+p*dx>1.14)
                    [~,position] = ode45(derivative,[0,t],[xi+p*dx,yi+q*dy]);
                    [end_position,~] = size(position);
                    scatter(position(end_position,1),position(end_position,2),'o','filled','k');
                elseif (xi+p*dx<1.12)
                    [~,position] = ode45(derivative,[0 t],[xi+p*dx,yi+q*dy]);
                    [end_position,~] = size(position);
                    scatter(position(end_position,1),position(end_position,2),'o','filled','w');
                end
            end
        end
    end
    drawnow;
    hold off;


%    F = getframe(gcf);
%    open(mov);
%    writeVideo(mov,F);

end
% close(mov);
