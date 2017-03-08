datapath = 'C:\Users\Nick\Documents\Courses\Mechanics of Biological Tissues\Final Project\tendon-model-fitting\data';
resultspath = 'C:\Users\Nick\Documents\Courses\Mechanics of Biological Tissues\Final Project\tendon-model-fitting\results';

% Create data and results structs
sdat = sampledata(datapath);
data = ramp(datapath);
results = struct();

% Set max isometric force
Fmax = 75;

% Set conditions, samples, and strain rates
cond = {'control'};
sample = {'S1'}; 
test = {'low'};

for c = 1:length(cond)
    for s = 1:length(sample)
        for t = 1:length(test)
            
            % Sample data
            lo = sdat.(cond{c}).(sample{s}).lo;
            A = sdat.(cond{c}).(sample{s}).Aell;
            
            % Trial data
            l = data.(cond{c}).(sample{s}).(test).ext;
            F = data.(cond{c}).(sample{s}).(test).load;
            
            % Tendon measurements to fit
            lmda = (l/lo)+1;   % strain
            F_tilde = F/Fmax;  % normalized force
            T = F/A;           % Piola stress
            
            % Recover tendon slack length estimation
            if strcmp(test{t},'high')
                tendonSlackLength = l(1);
                results.(cond{c}).(sample{s}).(test).lTs = tendonSlackLength;
                l = l-tendonSlackLength;
            end
            
            figure
            plot(lmda,F_tilde)
            title([cond{c} ' / ' sample{s} ' / ' test{t}])
            text(1.002,1.1,'Select two points (Millard/Thelen models): ')
            text(1.002,1.05,'  1) Curve intersection at one normalized force')
            text(1.002,1.0,'  2) Curve intersection at toe region end')
            [X,Y] = ginput(2);
            
            % Millard tendon model fitting
            [eIso,kIso,fToe,curviness,F_tilde_fit] = bestFitMillard(lmda,F_tilde,X,Y);
            results.(cond{c}).(sample{s}).(test).Millard.eIso = eIso;
            results.(cond{c}).(sample{s}).(test).Millard.kIso = kIso;
            results.(cond{c}).(sample{s}).(test).Millard.fToe = fToe;
            results.(cond{c}).(sample{s}).(test).Millard.curviness = curviness;
            
            % Thelen tendon model fitting TODO
            % [eToe,fToe,kToe,kLin] = bestFitThelen(lmda,F_tilde,X,Y)
            % results.(cond{c}).(sample{s}).(test).Thelen.eToe = eToe
            % results.(cond{c}).(sample{s}).(test).Thelen.fToe = fToe
            % results.(cond{c}).(sample{s}).(test).Thelen.kToe = kToe
            % results.(cond{c}).(sample{s}).(test).Thelen.kLin = kLin
            
            % HW2 tendon model fitting
            [alpha,beta,Etan0,Etan20] = bestFitHW2(lmda,T);
            results.(cond{c}).(sample{s}).(test).HW2.alpha = alpha;
            results.(cond{c}).(sample{s}).(test).HW2.beta = beta;
            results.(cond{c}).(sample{s}).(test).HW2.Etan0 = Etan0;
            results.(cond{c}).(sample{s}).(test).HW2.Etan20 = Etan20;
            
            
            
%             hold on
%             plot(lmda,F_tilde_fit)
%             legend('data','fit')
            
        end
    end
end

save(fullfile(resultspath,'results.mat'),'results')
generateResults(results)

