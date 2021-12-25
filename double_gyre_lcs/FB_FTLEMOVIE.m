
load('double_gyre_ftle_values_0to10s.mat');
endtime = 1200;
%mov = VideoWriter('Double Gyre FB FTLE.avi');
%mov.FrameRate = 10;

for i=1:endtime+1
    
    j=rem(i,101)+1;
    sgtitle("Time = "+num2str(i*0.1-0.1))
    subplot(1,2,1)
    imagesc([0 2],[0 1],reshape(ftleValuesf(j,:),fliplr(resolution)));
    box on;grid on;set(gca,'YDir','normal');title(gca,"Forward Time FTLE");
    subplot(1,2,2)
    imagesc([0 2],[0 1],reshape(ftleValuesb(j,:),fliplr(resolution)));
    box on;grid on;set(gca,'YDir','normal');title(gca,"Backward Time FTLE");
    drawnow;

    %F = getframe(gcf);
    %open(mov);
    %writeVideo(mov,F);

end
%close(mov);