boxpath = 'C:\Users\Nick\Box Sync\tendon-model-fitting\results';

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
    for s = 1:length(sample)
        for t = 1:length(test)
            
            time = sim_results.(cond).(sample{s}).(test{t}).outputs.time(:,1);
            
            height(:,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.height(:,1);
            fiber_length(:,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.fiber_length(:,1);
            tendon_length(:,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_length(:,1);
            tendon_stiffness(:,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_stiffness(:,1);
            fiber_velocity(:,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.fiber_velocity(:,1);
            active_fiber_force(:,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.active_fiber_force(:,1);
            tendon_force(:,s) = sim_results.(cond).(sample{s}).(test{t}).outputs.tendon_force(:,1);

        end
        
        % Hopper height
        figure(fig_height)
        plot(time,mean(height,2))
        hold on
        xlabel('Time (s)')
        ylabel('Height (m)')
        legend('control','static','dynamic','Location','best')
        
        % Fiber length
        figure(fig_fiber_length)
        plot(time,mean(fiber_length,2))
        hold on
        xlabel('Time (s)')
        ylabel('Fiber length (m)')
        legend('control','static','dynamic','Location','best')
        
        % Tendon length
        figure(fig_tendon_length)
        plot(time,mean(tendon_length,2))
        hold on
        xlabel('Time (s)')
        ylabel('Tendon length (m)')
        legend('control','static','dynamic','Location','best')
        
        % Tendon stiffness
        figure(fig_tendon_stiffness)
        plot(time,mean(tendon_stiffness,2))
        hold on
        xlabel('Time (s)')
        ylabel('Tendon stiffness (N/m)')
        legend('control','static','dynamic','Location','best')
        
        % Active fiber force
        figure(fig_active_fiber_force)
        plot(time,mean(active_fiber_force,2))
        hold on
        xlabel('Time (s)')
        ylabel('Active fiber force (N)')
        legend('control','static','dynamic','Location','best')
        
        % Tendon force
        figure(fig_tendon_force)
        plot(time,mean(tendon_force,2))
        hold on
        xlabel('Time (s)')
        ylabel('Tendon force (N)')
        legend('control','static','dynamic','Location','best')
        
        % Fiber velocity
        figure(fig_fiber_velocity)
        plot(time,mean(fiber_velocity,2))
        hold on
        xlabel('Time (s)')
        ylabel('Fiber velocity (m/s)')
        legend('control','static','dynamic','Location','best')
        
    end
end

print(fig_height,fullfile(boxpath,'height'),'-djpeg')
print(fig_fiber_length,fullfile(boxpath,'fiber_length'),'-djpeg')
print(fig_tendon_length,fullfile(boxpath,'tendon_length'),'-djpeg')
print(fig_tendon_stiffness,fullfile(boxpath,'fiber_velocity'),'-djpeg')
print(fig_active_fiber_force,fullfile(boxpath,'active_fiber_force'),'-djpeg')
print(fig_tendon_force,fullfile(boxpath,'tendon_force'),'-djpeg')
