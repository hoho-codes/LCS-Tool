
%% Script to plot how the FTLE Fields change over time alongwith the evolution of some particles.
%% To generate a movie file comment out lines 25,26,109,110,111,112,115

% Location of Initial Points
xi = 0.8;yi = 0;
xf = 1.4;yf = 0.4;
n = 8;
dx=(xf-xi)/(n-1);
dy=(yf-yi)/(n-1);

% Double Gyre Parameters
epsilon = 0.25;
amplitude = .1;
omega = pi/5;
lDerivative = @(t,x,~)derivative(t,x,false,epsilon,amplitude,omega);

% the '.mat' file has to be generated before running the script. Use
% DG_FB_FTLE_DATA_GENERATOR.m to generate it.
load('double_gyre_ftle_values_0to10s.mat');

% Length of the movie in 0.1s. Default value set is 2 minutes.
endtime = 1200;

% mov = VideoWriter('DG_FB_FTLE_8^2_PARTICLES.avi');
% mov.FrameRate = 10;

for i=1:endtime+1
    t=i*0.1-0.1;
    
    % rem function used as data is available for 101 timeshots but FTLE
    % Fields are periodic
    j=rem(i,101)+1;
    
    sgtitle("Time = "+num2str(t))
    
    % Forward time FTLE with particles
    subplot(1,2,1)
    imagesc([0 2],[0 1],reshape(ftleValuesf(j,:),fliplr(resolution)));
    box on;grid on;set(gca,'YDir','normal');title(gca,"Forward Time FTLE");hold on;
    if(t==0)
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
                    [~,position] = ode45(lDerivative,[0,t],[xi+p*dx,yi+q*dy]);
                    [last_pos,~] = size(position);
                    scatter(position(last_pos,1),position(last_pos,2),'o','filled','k');
                elseif (xi+p*dx<1.12)
                    [~,position] = ode45(lDerivative,[0 t],[xi+p*dx,yi+q*dy]);
                    [last_pos,~] = size(position);
                    scatter(position(last_pos,1),position(last_pos,2),'o','filled','w');  
                end
            end
        end
    end
    drawnow;
    hold off;
    
    % Backward time FTLE with particles
    subplot(1,2,2)
    imagesc([0 2],[0 1],reshape(ftleValuesb(j,:),fliplr(resolution)));
    box on;grid on;set(gca,'YDir','normal');title(gca,"Backward Time FTLE");hold on;
    if(t==0)
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
                    [~,position] = ode45(lDerivative,[0,t],[xi+p*dx,yi+q*dy]);
                    [last_pos,~] = size(position);
                    scatter(position(last_pos,1),position(last_pos,2),'o','filled','k');
                elseif (xi+p*dx<1.12)
                    [~,position] = ode45(lDerivative,[0 t],[xi+p*dx,yi+q*dy]);
                    [last_pos,~] = size(position);
                    scatter(position(last_pos,1),position(last_pos,2),'o','filled','w');
                end
            end
        end
    end
    drawnow;
    hold off;

%     pause(1);
%     F = getframe(gcf);
%     open(mov);
%     writeVideo(mov,F);

end
% close(mov);
