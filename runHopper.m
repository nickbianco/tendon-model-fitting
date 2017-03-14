%-----------------------------------------------------------------------%
% The OpenSim API is a toolkit for musculoskeletal modeling and         %
% simulation. See http://opensim.stanford.edu and the NOTICE file       %
% for more information. OpenSim is developed at Stanford University     %
% and supported by the US National Institutes of Health (U54 GM072970,  %
% R24 HD065690) and by DARPA through the Warrior Web program.           %
%                                                                       %
% Copyright (c) 2017 Stanford University and the Authors                %
% Author(s): Thomas Uchida, Chris Dembia, Carmichael Ong, Nick Bianco,  %
%            Shrinidhi K. Lakshmikanth, Ajay Seth, James Dunne          %
%                                                                       %
% Licensed under the Apache License, Version 2.0 (the "License");       %
% you may not use this file except in compliance with the License.      %
% You may obtain a copy of the License at                               %
% http://www.apache.org/licenses/LICENSE-2.0.                           %
%                                                                       %
% Unless required by applicable law or agreed to in writing, software   %
% distributed under the License is distributed on an "AS IS" BASIS,     %
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or       %
% implied. See the License for the specific language governing          %
% permissions and limitations under the License.                        %
%-----------------------------------------------------------------------%

% Build and simulate a single-legged hopping mechanism.

function [results] = runHopper(varargin)

resultspath = 'C:\Users\Nick\Documents\Courses\Mechanics of Biological Tissues\Final Project\tendon-model-fitting\results';
boxpath = 'C:\Users\Nick\Box Sync\tendon-model-fitting';

p = inputParser();

defaultHopper = BuildHopper();
defaultEnableVisualizer = true;

addOptional(p,'hopper',defaultHopper)
addOptional(p,'enableVisualizer',defaultEnableVisualizer)

parse(p,varargin{:});

hopper = p.Results.hopper;
enableVisualizer = p.Results.enableVisualizer;



import org.opensim.modeling.*;
% Discover the subcomponents in the hopper, and the outputs available for
% reporting. Identify the outputs for the hopper's height and muscle
% activation.

hopper.printSubcomponentInfo();
hopper.getComponent('slider').printOutputInfo();
hopper.getComponent('vastus').printOutputInfo();

% Create a TableReporter, give it a name, and set its reporting interval
% to 0.2 seconds. Wire the hopper's height and muscle activation
% outputs to the reporter. Then add the reporter to the hopper.
% Adding an output to the reporter looks like the following; the alias
% becomes the column label in the table. 
% reporter.addToReport(...
% hopper.getComponent('<comp-path>').getOutput('<output-name>'), ...
%                     '<alias>');

reporter = TableReporter();
reporter.setName('hopper_results');
reporter.set_report_time_interval(0.01); % seconds
reporter.addToReport( hopper.getComponent('slider/yCoord').getOutput('value'), 'height');
reporter.addToReport( hopper.getComponent('vastus').getOutput('activation'), 'activation'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('active_fiber_force'), 'active_fiber_force');
%reporter.addToReport( hopper.getComponent('vastus').getOutput('active_fiber_force_along_tendon'), 'active_fiber_force_along_tendon');
reporter.addToReport( hopper.getComponent('vastus').getOutput('active_force_length_multiplier'), 'active_force_length_multiplier'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('actuation'), 'actuation'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('cos_pennation_angle'), 'cos_pennation_angle'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_active_power'), 'fiber_active_power'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_force'), 'fiber_force'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_force_along_tendon'), 'fiber_force_along_tendon'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_length'), 'fiber_length'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_length_along_tendon'), 'fiber_length_along_tendon'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_passive_power'), 'fiber_passive_power'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_stiffness'), 'fiber_stiffness'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_velocity'), 'fiber_velocity'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('fiber_velocity_along_tendon'), 'fiber_velocity_along_tendon'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('force_velocity_multiplier'), 'force_velocity_multiplier'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('muscle_power'), 'muscle_power'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('muscle_stiffness'), 'muscle_stiffness'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('normalized_fiber_length'), 'normalized_fiber_length'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('normalized_fiber_velocity'), 'normalized_fiber_velocity'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('passive_fiber_damping_force'), 'passive_fiber_damping_force'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('passive_fiber_elastic_force'), 'passive_fiber_elastic_force'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('passive_fiber_force'), 'passive_fiber_force'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('passive_fiber_force_along_tendon'), 'passive_fiber_force_along_tendon'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('passive_force_multiplier'), 'passive_force_multiplier'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('pennation_angle'), 'pennation_angle'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('pennation_angular_velocity'), 'pennation_angular_velocity'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('potential_energy'), 'potential_energy'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('power'), 'power'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('speed'), 'speed'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('tendon_force'), 'tendon_force'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('tendon_length'), 'tendon_length'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('tendon_power'), 'tendon_power'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('tendon_stiffness'), 'tendon_stiffness'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('tendon_strain'), 'tendon_strain'); 
reporter.addToReport( hopper.getComponent('vastus').getOutput('tendon_velocity'), 'tendon_velocity'); 
%reporter.addToReport( hopper.getComponent('vastus').getOutput('tension'), 'tension'); 

hopper.addComponent(reporter);

sHop = hopper.initSystem();
% The last argument determines if the simbody-visualizer should be used.
Simulate(hopper, sHop, enableVisualizer);

% Display the TableReporter's data, and save it to a file.

table = reporter.getTable();
disp(table.toString());
csv = CSVFileAdapter();

csv.write(table,fullfile(resultspath,'hopper_results.csv'));
csv.write(table,fullfile(boxpath,'results','hopper_results.csv'));
  
% Convert the TableReporter's Table to a MATLAB struct and plot the
% the hopper's height over the motion.

results = opensimTimeSeriesTableToMatlab(table);
fieldnames(results)
figure;
plot(results.time, results.height);
hold on
plot(results.time, results.activation)
xlabel('time');
ylabel('height');


end
