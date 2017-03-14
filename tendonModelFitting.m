datapath = 'C:\Users\Nick\Documents\Courses\Mechanics of Biological Tissues\Final Project\tendon-model-fitting\data';
resultspath = 'C:\Users\Nick\Documents\Courses\Mechanics of Biological Tissues\Final Project\tendon-model-fitting\results';
boxpath = 'C:\Users\Nick\Box Sync\tendon-model-fitting';

% Original sample numbers from instron tests
mapping = struct();
mapping.control.S1 = 'Sample 18';
mapping.control.S2 = 'empty';
mapping.control.S3 = 'empty';
mapping.static.S1 = 'Sample 14';
mapping.static.S2 = 'empty';
mapping.static.S3 = 'empty';
mapping.dynamic.S1 = 'Sample 17';
mapping.dynamic.S2 = 'empty';
mapping.dynamic.S3 = 'empty';

% Set conditions, samples, and strain rates
conditions = { ...%{'control',{'S1'}} , ...
               {'static' ,{'S1'}}};% , ...
               %{'dynamic',{'S1'}} };
test = {'low','high'};

% Create data and results structs
sdat = sampledata(datapath);
data = ramp(datapath,conditions);
results = struct();

save(fullfile(boxpath,'data','sampledata.mat'),'sdat')
save(fullfile(boxpath,'data','trialdata.mat'),'data')

try load(fullfile(resultspath,'results.mat'))
catch ME
    control = struct();
    save(fullfile(resultspath,'results.mat'),'control')
end
% Set max isometric force
Fmax = 75;

for c = 1:length(conditions)
    cond = conditions{c}{1};
    sample = conditions{c}{2};
    for s = 1:length(sample)
        for t = 1:length(test)
            
            results.(cond).(sample{s}).mapping = mapping.(cond).(sample{s});
            
            % Sample data
            lo = sdat.(cond).(sample{s}).lo;
            A = sdat.(cond).(sample{s}).Aell;
            
            % Trial data
            l = data.(cond).(sample{s}).(test{t}).ext;
            F = data.(cond).(sample{s}).(test{t}).load;
            
            % Recover tendon slack length estimation
            if ~strcmp(cond,'control') && strcmp(test{t},'low')
                results.(cond).(sample{s}).lTs_est = l(1);
            end
              
            % Tendon measurements to fit
            l = l-l(1);
            lmda = (l/lo)+1;   % strain
            F_tilde = F/Fmax;  % normalized force
            T = F/A;           % Piola stress
            
            results.(cond).(sample{s}).(test{t}).lmda = lmda;
            results.(cond).(sample{s}).(test{t}).F_tilde = F_tilde;
            results.(cond).(sample{s}).(test{t}).T = T;
            
            figure
            plot(lmda,F_tilde)
            title([cond ' / ' sample{s} ' / ' test{t}])
            text(1.002,max(F_tilde)-0.1,'Select two points (Millard/Thelen models): ')
            text(1.002,max(F_tilde)-0.167,'  1) Curve intersection at one normalized force')
            text(1.002,max(F_tilde)-0.23,'  2) Curve intersection at toe region end')
            [X,Y] = ginput(2);
            
            % Millard tendon model fitting
            [eIso,kIso,fToe,curviness,F_tilde_fit] = bestFitMillard(lmda,F_tilde,X,Y);
            results.(cond).(sample{s}).(test{t}).Millard.eIso = eIso;
            results.(cond).(sample{s}).(test{t}).Millard.kIso = kIso;
            results.(cond).(sample{s}).(test{t}).Millard.fToe = fToe;
            results.(cond).(sample{s}).(test{t}).Millard.curviness = curviness;
            
            % Thelen tendon model fitting TODO
            % [eToe,fToe,kToe,kLin] = bestFitThelen(lmda,F_tilde,X,Y)
            % results.(cond).(sample{s}).(test{t}).Thelen.eToe = eToe
            % results.(cond).(sample{s}).(test{t}).Thelen.fToe = fToe
            % results.(cond).(sample{s}).(test{t}).Thelen.kToe = kToe
            % results.(cond).(sample{s}).(test{t}).Thelen.kLin = kLin
            
            % HW2 tendon model fitting
            [alpha,beta,Etan0,Etan20,T_fit] = bestFitHW2(lmda,T);
            results.(cond).(sample{s}).(test{t}).HW2.alpha = alpha;
            results.(cond).(sample{s}).(test{t}).HW2.beta = beta;
            results.(cond).(sample{s}).(test{t}).HW2.Etan0 = Etan0;
            results.(cond).(sample{s}).(test{t}).HW2.Etan20 = Etan20;
            
            hold on
            plot(lmda,F_tilde_fit)
            
            figure
            plot(lmda,T)
            hold on
            plot(lmda,T_fit)
            
            save(fullfile(resultspath,'results.mat'),'-append','-struct','results') %,cond,sample{s},test{t})
            save(fullfile(boxpath,'results','results.mat'),'-append','-struct','results')
        end
    end
end

