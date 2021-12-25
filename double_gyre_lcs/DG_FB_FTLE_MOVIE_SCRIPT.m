
%% Script to plot how the FTLE Fields change over time.
%% To generate a movie file comment out lines 12,13,30,31,32,35.

% the '.mat' file has to be generated before running the script. Use
% DG_FB_FTLE_DATA_GENERATOR.m to generate it.
load('double_gyre_ftle_values_0to10s.mat');

% Length of the movie in 0.1s. Default value set is 2 minutes.
endtime = 1200;

%mov = VideoWriter('DG_FB_FTLE.avi');
%mov.FrameRate = 10;

for i=1:endtime+1
    
    % rem function used as data is available for 101 timeshots but FTLE
    % Fields are periodic
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
