function plotSimulationResults

boxpath = 'C:\Users\Nick\Box Sync\tendon-model-fitting\results';

data = load('sim_results.mat');
sim_results = data.sim_results;

conditions = { {'control',{'S1'}} , ...
    {'static' ,{'S1'}} , ...
    {'dynamic',{'S1'}} };
test = {'low','high'};

figure; fig_height = gcf;
figure; fig_fiber_length = gcf;
figure; fig_tendon_length = gcf;
figure; fig_tendon_stiffness = gcf;
figure; fig_fiber_velocity = gcf;
figure; fig_active_fiber_force = gcf;
figure; fig_tendon_force = gcf;

% Generate plots
for c = 1:length(conditions)
    cond = conditions{c}{1};
    sample = conditions{c}{2};
    
    %height = zeros(501,length(test),length(sample));
    for s = 1:length(sample)
        for t = 1:length(test)
            
            time = sim_results.(cond).(sample{s}).(test{t}).outputs.time(:,1);
            
            height(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.height(:,1);
            fiber_length(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.fiber_length(:,1);
            tendon_length(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_length(:,1);
            tendon_stiffness(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_stiffness(:,1);
            fiber_velocity(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.fiber_velocity(:,1);
            active_fiber_force(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.active_fiber_force(:,1);
            tendon_force(:,t,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_force(:,1);
            
        end
        
    end
    
    plotFun(fig_height,time,height,'Height (s)')
    plotFun(fig_fiber_length,time,fiber_length,'Fiber Length (m)')
    plotFun(fig_tendon_length,time,tendon_length,'Tendon Length (m)')
    plotFun(fig_tendon_stiffness,time,tendon_stiffness,'Tendon Stiffness (N/m)')
    plotFun(fig_active_fiber_force,time,active_fiber_force,'Active Fiber Force (N)')
    plotFun(fig_tendon_force,time,tendon_force,'Tendon Force (N)')
end

print(fig_height,fullfile(boxpath,'height'),'-djpeg')
print(fig_fiber_length,fullfile(boxpath,'fiber_length'),'-djpeg')
print(fig_tendon_length,fullfile(boxpath,'tendon_length'),'-djpeg')
print(fig_tendon_stiffness,fullfile(boxpath,'fiber_velocity'),'-djpeg')
print(fig_active_fiber_force,fullfile(boxpath,'active_fiber_force'),'-djpeg')
print(fig_tendon_force,fullfile(boxpath,'tendon_force'),'-djpeg')

end

function plotFun(fig_h,time,value,y_label)

figure(fig_h)

subplot(1,2,1)
plot(time,mean(value(:,1,:),3))
title('Low Strain Rate')
hold on
xlabel('Time (s)')
ylabel(y_label)

subplot(1,2,2)
plot(time,mean(value(:,2,:),3))
title('High Strain Rate')
hold on
xlabel('Time (s)')
ylabel(y_label)
legend('control','static','dynamic','Location','best')



end
