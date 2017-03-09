clear all;

pathToHopper = 'C:\Users\Nick\repos\opensim\opensim-core\Bindings\Java\Matlab\Hopper_Device';
addpath(pathToHopper)

conditions = { {'control',{'S1'}} , ...
               {'static' ,{'S1'}} , ...
                {'dynamic',{'S1'}} };
test = {'low','high'};

for c = 1:length(conditions)
    cond = conditions{c}{1};
    sample = conditions{c}{2};
    for s = 1:length(sample)
        for t = 1:length(test)
                      
        hopper = BuildHopper('muscleModel','Millard2012Equilibrium', ...
                             'maxIsometricForce', 9000, ...
                             'printModel',true);
        runHopper('hopper',hopper,'enableVisualizer',false)
        keyboard
            
        end
    end
end

%hopper = BuildHopper('muscleModel','Millard2012Equilibrium','printModel',true);
