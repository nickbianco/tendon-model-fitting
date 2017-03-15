function plotSimulationResults

boxpath = 'C:\Users\Nick\Box Sync\tendon-model-fitting\results';

data = load('results\sim_results.mat');
sim_results = data.sim_results;

conditions = { {'control',{'S1','S2','S3'}} , ...
               {'static' ,{'S1','S2','S3'}} , ...
               {'dynamic',{'S1','S2','S3'}} };
test = {'low','high'};

offset = 5;

figure; fig_height = gcf;
figure; fig_fiber_length = gcf;
figure; fig_normalized_fiber_length = gcf;
figure; fig_tendon_length = gcf;
figure; fig_tendon_stiffness = gcf;
figure; fig_fiber_velocity = gcf;
figure; fig_active_fiber_force = gcf;
figure; fig_active_fiber_power = gcf;
figure; fig_passive_fiber_force = gcf;
figure; fig_tendon_force = gcf;
figure; fig_tendon_power = gcf;

% Generate plots
for c = 1:length(conditions)
    cond = conditions{c}{1};
    sample = conditions{c}{2};
    
    %height = zeros(501,length(test),length(sample));
    for s = 1:length(sample)
        for t = 1:length(test)
            
            time = sim_results.(cond).(sample{s}).(test{t}).outputs.time(offset:end,1);
            
            height(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.height(offset:end,1);
            fiber_length(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.fiber_length(offset:end,1);
            normalized_fiber_length(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.normalized_fiber_length(offset:end,1);
            tendon_length(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_length(offset:end,1);
            tendon_stiffness(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_stiffness(offset:end,1);
            fiber_velocity(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.fiber_velocity(offset:end,1);
            active_fiber_force(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.active_fiber_force(offset:end,1);
            active_fiber_power(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.fiber_active_power(offset:end,1);
            passive_fiber_force(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.passive_fiber_force(offset:end,1);
            tendon_force(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_force(offset:end,1);
            tendon_power(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_power(offset:end,1);
            
        end
        
    end
   
    switch cond
        case 'control'
            S = 'k';
        case 'static'
            S = 'r';
        case 'dynamic'
            S = 'b';
    end
 
    plotFun(fig_height,time,height,'Height (s)',S)
    plotFun(fig_fiber_length,time,fiber_length,'Fiber Length (m)',S)
    plotFun(fig_normalized_fiber_length,time,fiber_length,'Normalized Fiber Length',S)
    plotFun(fig_fiber_velocity,time,fiber_velocity,'Fiber Velocity (m/s)',S)
    plotFun(fig_tendon_length,time,tendon_length,'Tendon Length (m)',S)
    plotFun(fig_tendon_stiffness,time,tendon_stiffness,'Tendon Stiffness (N/m)',S)
    plotFun(fig_active_fiber_force,time,active_fiber_force,'Active Fiber Force (N)',S)
    plotFun(fig_active_fiber_power,time,active_fiber_power,'Active Fiber Power (W)',S)
    plotFun(fig_passive_fiber_force,time,passive_fiber_force,'Passive Fiber Force (N)',S)
    plotFun(fig_tendon_force,time,tendon_force,'Tendon Force (N)',S)
    plotFun(fig_tendon_power,time,tendon_power,'Tendon Power (W)',S)
end

print(fig_height,fullfile(boxpath,'height'),'-djpeg')
print(fig_fiber_length,fullfile(boxpath,'fiber_length'),'-djpeg')
print(fig_normalized_fiber_length,fullfile(boxpath,'normalized_fiber_length'),'-djpeg')
print(fig_fiber_velocity,fullfile(boxpath,'fiber_velocity'),'-djpeg')
print(fig_tendon_length,fullfile(boxpath,'tendon_length'),'-djpeg')
print(fig_tendon_stiffness,fullfile(boxpath,'tendon_stiffness'),'-djpeg')
print(fig_active_fiber_force,fullfile(boxpath,'active_fiber_force'),'-djpeg')
print(fig_active_fiber_power,fullfile(boxpath,'active_fiber_power'),'-djpeg')
print(fig_passive_fiber_force,fullfile(boxpath,'passive_fiber_force'),'-djpeg')
print(fig_tendon_force,fullfile(boxpath,'tendon_force'),'-djpeg')
print(fig_tendon_power,fullfile(boxpath,'tendon_power'),'-djpeg')

end

function plotFun(fig_h,time,value,y_label,S)

figure(fig_h)

subplot(1,2,1)
meanVal = mean(value(:,1,:),3);
stdVal = std(value(:,1,:),0,3);

plot(time,meanVal,[S '-'])
hold on
%plot(time,meanVal+stdVal,[S '--'])
%plot(time,meanVal-stdVal,[S '--'])

title('Low Strain Rate')
hold on
xlabel('Time (s)')
ylabel(y_label)

subplot(1,2,2)
meanVal = mean(value(:,2,:),3);
stdVal = std(value(:,2,:),0,3);

plot(time,meanVal,[S '-'])
hold on
%plot(time,meanVal+stdVal,[S '--'])
%plot(time,meanVal-stdVal,[S '--'])
title('High Strain Rate')
hold on
xlabel('Time (s)')
ylabel(y_label)
legend('control','static','dynamic','Location','best')

end
