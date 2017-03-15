function generateSimulations

clear all; clc;
datapath = 'C:\Users\Nick\Documents\Courses\Mechanics of Biological Tissues\Final Project\tendon-model-fitting\data';
resultspath = 'C:\Users\Nick\Documents\Courses\Mechanics of Biological Tissues\Final Project\tendon-model-fitting\results';
boxpath = 'C:\Users\Nick\Box Sync\tendon-model-fitting';
pathToHopper = 'C:\Users\Nick\repos\opensim\opensim-core\Bindings\Java\Matlab\Hopper_Device';
addpath(pathToHopper)

plotDefaults()

% Load results
sdat = load(fullfile(datapath,'sampledata.mat'));
results = load(fullfile(resultspath,'results.mat'));

% Simulation results struct
sim_results = struct();

% Default Millard TendonForceLengthCurve parameters
eIso = 0.049;
kIso = 1.375/eIso;
fToe = 2.0/3.0;
curviness = 0.5;
lTs = 0.25;

% Set conditions to run hopper
conditions = { {'control',{'S1','S2','S3'}} , ...
               {'static' ,{'S1','S2','S3'}} , ...
               {'dynamic',{'S1','S2','S3'}} };
test = {'low','high'};

%% Use control samples to calculate parameter reference points
cond = conditions{1}{1};
sample = conditions{1}{2};
for t = 1:length(test)
    for s = 1:length(sample)
        eIso_control(s) = results.(cond).(sample{s}).(test{t}).Millard.eIso;
        kIso_control(s) = results.(cond).(sample{s}).(test{t}).Millard.kIso;
        fToe_control(s) = results.(cond).(sample{s}).(test{t}).Millard.fToe;
        curviness_control(s) = results.(cond).(sample{s}).(test{t}).Millard.curviness;
    end
    sim_results.(cond).(test{t}).eIso.mean = mean(eIso_control);
    sim_results.(cond).(test{t}).eIso.std = std(eIso_control);
    sim_results.(cond).(test{t}).kIso.mean = mean(kIso_control);
    sim_results.(cond).(test{t}).kIso.std = std(kIso_control);
    sim_results.(cond).(test{t}).fToe.mean = mean(fToe_control);
    sim_results.(cond).(test{t}).fToe.std = std(fToe_control);
    sim_results.(cond).(test{t}).curviness.mean = mean(curviness_control);
    sim_results.(cond).(test{t}).curviness.std = std(curviness_control);
end

%% Hopper simulations
for c = 1:length(conditions)
    cond = conditions{c}{1};
    sample = conditions{c}{2};
    for s = 1:length(sample)
        for t = 1:length(test)
            
            % Get model fit parameters for cond/sample/test
            eIso_fit = results.(cond).(sample{s}).(test{t}).Millard.eIso;
            kIso_fit = results.(cond).(sample{s}).(test{t}).Millard.kIso;
            fToe_fit = results.(cond).(sample{s}).(test{t}).Millard.fToe;
            curviness_fit = results.(cond).(sample{s}).(test{t}).Millard.curviness;
            
            % Get test grip to grip length
            lo = sdat.sdat.(cond).(sample{s}).lo;
            
            % Recover tendon slack length change estimation
            if ~strcmp(cond,'control')
                lTs_est = results.(cond).(sample{s}).lTs_est;
            else
                lTs_est = 0;
            end
            
            % Based on fit parameters, create scale factors to modify
            % default tendon parameters of the hopper vastus muscle
            % for preconditioning
            eIso_ref = sim_results.control.(test{t}).eIso.mean;
            kIso_ref = sim_results.control.(test{t}).kIso.mean;
            fToe_ref = sim_results.control.(test{t}).fToe.mean;
            curviness_ref = sim_results.control.(test{t}).curviness.mean;
            
            eIso_scaled = eIso*(1 + (eIso_fit-eIso_ref) / eIso_ref )
            kIso_scaled = kIso*(1 + (kIso_fit-kIso_ref) / kIso_ref )           
            fToe_scaled = scaleFcn(fToe,fToe_fit,fToe_ref)
            curviness_scaled = scaleFcn(curviness,curviness_fit,curviness_ref)
            lTs_scaled = lTs*( (lo+lTs_est) / lo)
            
            % Build hopper
            hopper = BuildHopper('muscleModel','Millard2012Equilibrium', ...
                'MillardTendonParams', [eIso_scaled kIso_scaled fToe_scaled curviness_scaled lTs_scaled], ...
                'maxIsometricForce', 9000, ...
                'printModel',true);
            
            % Simulate hopper and generate results
            outputs = runHopper('hopper',hopper,'enableVisualizer',false );
            
            sim_results.(cond).(sample{s}).(test{t}).eIso_scaled = eIso_scaled;
            sim_results.(cond).(sample{s}).(test{t}).kIso_scaled = kIso_scaled;
            sim_results.(cond).(sample{s}).(test{t}).fToe_scaled = fToe_scaled;
            sim_results.(cond).(sample{s}).(test{t}).curviness_scaled = curviness_scaled;
            sim_results.(cond).(sample{s}).(test{t}).lTs_scaled = lTs_scaled;
            sim_results.(cond).(sample{s}).(test{t}).outputs = outputs;
            
            disp('Press <enter> to run next hopper simulation...')
            pause
            
        end
    end
end

save(fullfile(resultspath,'sim_results.mat'),'sim_results')
save(fullfile(boxpath,'results','sim_results.mat'),'sim_results')

end

function [param_scaled] = scaleFcn(param,param_fit,param_ref)

if (param_fit - param_ref) > 0
    param_scaled = param*(1 + (param_fit - param_ref)/(1-param_ref) );
else
    param_scaled = param*(1 + (param_fit - param_ref)/param_ref );
end

end
