
%% Location of Initial Points
xi = 0.8;yi = 0;
xf = 1.4;yf = 0.4;
n = 8;
dx=(xf-xi)/(n-1);
dy=(yf-yi)/(n-1);

%% Double Gyre Parameters
epsilon = 0.5;
amplitude = .1;
omega = pi/5;
lDerivative = @(t,x,~)derivative(t,x,false,epsilon,amplitude,omega);

load('double_gyre_ftle_values_0to10s.mat');
endtime = 1200;
mov = VideoWriter('Double Gyre FB FTLE with 8^2 particles.avi');
mov.FrameRate = 10;

for i=1:endtime+1
    t=i*0.1-0.1;
    j=rem(i,101)+1;
    sgtitle("Time = "+num2str(t))
    subplot(1,2,1)
    imagesc([0 2],[0 1],reshape(ftleValuesf(j,:),fliplr(resolution)));
    box on;grid on;set(gca,'YDir','normal');title(gca,"Forward Time FTLE");hold on;
    if(t==0)
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
        for p=0:n-1
            for q=0:n-1
                if (xi+p*dx>1.14)
                    [~,xr] = ode45(lDerivative,[0,t],[xi+p*dx,yi+q*dy]);
                    [hmm,~] = size(xr);
                    scatter(xr(hmm,1),xr(hmm,2),'o','filled','k');
                elseif (xi+p*dx<1.12)
                    [~,xr] = ode45(lDerivative,[0 t],[xi+p*dx,yi+q*dy]);
                    [hmm,~] = size(xr);
                    scatter(xr(hmm,1),xr(hmm,2),'o','filled','w');  
                end
            end
        end
    end
    drawnow;
    hold off;
    subplot(1,2,2)
    imagesc([0 2],[0 1],reshape(ftleValuesb(j,:),fliplr(resolution)));
    box on;grid on;set(gca,'YDir','normal');title(gca,"Backward Time FTLE");hold on;
    if(t==0)
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
        for p=0:n-1
            for q=0:n-1
                if (xi+p*dx>1.14)
                    [~,xr] = ode45(lDerivative,[0,t],[xi+p*dx,yi+q*dy]);
                    [hmm,~] = size(xr);
                    scatter(xr(hmm,1),xr(hmm,2),'o','filled','k');
                elseif (xi+p*dx<1.12)
                    [~,xr] = ode45(lDerivative,[0 t],[xi+p*dx,yi+q*dy]);
                    [hmm,~] = size(xr);
                    scatter(xr(hmm,1),xr(hmm,2),'o','filled','w');
                end
            end
        end
    end
    drawnow;
    hold off;

    pause(1);
    F = getframe(gcf);
    open(mov);
    writeVideo(mov,F);

end
close(mov);