
A = 0.1; w = pi/5; eps = 0.25; N = 128;
x=linspace(0,2,N);
y=linspace(0,1,N);
[xg,yg] = meshgrid(x,y);

xi = 0.8;yi = 0;
xf = 1.4;yf = 0.4;
n = 10;
dx=(xf-xi)/(n-1);
dy=(yf-yi)/(n-1);

% mov = VideoWriter('Double Gyre Flow Vorticity with Particles 20s.avi');
% mov.FrameRate = 10;

derivative = @(t,x,~)DoubleGyreDerivative(t,x,eps,w,A);
for i = 0:200
    

    t=i*0.1;
    %title(["Velocity and Vorticity","Time (in seconds) : "+num2str(t)]);
   
    f = (eps*sin(w*t))*xg.^2+(1-2*eps*sin(w*t)).*xg;
    dfdx = (2*eps*sin(w*t)).*xg+(1-2*eps*sin(w*t));
    d2fdx2 = (2*eps*sin(w*t));

%     u=-A*pi*(sin(pi*f)).*(cos(pi*yg));
%     v=A*pi*(sin(pi*yg)).*(cos(pi*f)).*dfdx;
    
    vort = A*pi*sin(pi*yg).*(-pi*sin(pi*f).*(dfdx.^2)+cos(pi*f)*d2fdx2-pi*sin(pi*f));
    %[vort1,~] = curl(xg,yg,u,v);
    
    
    imagesc(x,y,vort);set(gca,'YDir','normal');
    colorbar;hold on;
%     quiver(xg,yg,u,v,'b');
    xlim([0 2]);ylim([0 1]);
    
%     if(i==0)
%         for p=0:n-1
%             for q=0:n-1
%                 if (xi+p*dx>1.14)                    
%                     scatter(xi+p*dx,yi+q*dy,'o','filled','k');
% %                     xlim([0 2]);ylim([0 1]);
%                 elseif (xi+p*dx<1.12)                    
%                     scatter(xi+p*dx,yi+q*dy,'o','filled','w');
% %                     xlim([0 2]);ylim([0 1]);   
%                 end
%             end
%         end
%     else
%         for p=0:n-1
%             for q=0:n-1
%                 if (xi+p*dx>1.14)
%                     [~,xr] = ode45(derivative,[0,t],[xi+p*dx,yi+q*dy]);
%                     [hmm,~] = size(xr);
%                     scatter(xr(hmm,1),xr(hmm,2),'o','filled','k');
% %                     xlim([0 2]);ylim([0 1]);
%                 elseif (xi+p*dx<1.12)
%                     [~,xr] = ode45(derivative,[0 t],[xi+p*dx,yi+q*dy]);
%                     [hmm,~] = size(xr);
%                     scatter(xr(hmm,1),xr(hmm,2),'o','filled','w');
% %                     xlim([0 2]);ylim([0 1]);   
%                 end
%             end
%         end
%     end
      drawnow;
%     hold off;
    

%    F = getframe(gcf);
%    open(mov);
%    writeVideo(mov,F);

end
% close(mov);