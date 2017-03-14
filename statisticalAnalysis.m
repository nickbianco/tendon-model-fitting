function HW2_Q4
plotDefaults()

sdat = sampledata();
data = ramp();
results = struct();

group = {'B','C','D'};
rate = {'low','med','high'};

%% Organize results
for g = 1:length(group)
    for r = 1:length(rate)
       
    % Sample data
    lo = sdat.(group{g}).ramp.(rate{r}).lo;
    A = sdat.(group{g}).ramp.(rate{r}).Aell;
    
    % Trial data (truncated at max)
    l = data.(group{g}).(rate{r}).max.ext; 
    F = data.(group{g}).(rate{r}).max.load;
    
    results.(group{g}).(rate{r}).lmda_max = (l(end)/lo)+1;
    results.(group{g}).(rate{r}).T_max = (F(end)/A);
    results.(group{g}).(rate{r}).UTS = (F(end)/A)/(l(end)/lo);
           
    % Trial data (truncated for best fit)
    l = data.(group{g}).(rate{r}).fit.ext; 
    F = data.(group{g}).(rate{r}).fit.load;
    
    lmda = (l/lo)+1;
    T = F/A;
    [alpha,beta,Etan0,Etan20] = bestfit(lmda,T);
    
    results.(group{g}).(rate{r}).alpha = alpha;
    results.(group{g}).(rate{r}).beta = beta;
    results.(group{g}).(rate{r}).Etan0 = Etan0;
    results.(group{g}).(rate{r}).Etan20 = Etan20;
        
    end 
end

%% Generate plots
meas = {'T_max','lmda_max','UTS','alpha','beta','Etan0','Etan20'};
name = {'T_{max}','\lambda_{max}','UTS','\alpha','\beta','E_{tan}, \lambda = 1','E_{tan}, \lambda = 1.2'};
units = {'[MPa]','','[MPa]','','','[MPa]','[MPa]'};

for m = 1:length(meas)
    y = zeros(length(group),length(rate));
    ystat = zeros(size(y));
    grp = zeros(size(y));
    
    figure('Name',meas{m})
    for r = 1:length(rate)
        for g = 1:length(group)
            if strcmp(group{g},'C') && strcmp(rate{r},'low')
                continue;
            else
                y(g,r) = results.(group{g}).(rate{r}).(meas{m});
            end
        end
    end
   
    for i = 1:size(y,2)
        col = y(:,i);
        col = col(col~=0);
        y_mean(i) = mean(col,1);
        y_std(i) = std(col,0,1);
    end
    
    y = y(:)';
    ystat = y(y~=0);
    grp = rate(kron(1:3,ones(1,3)));
    grp = grp(y~=0);
 
    [p,~,stats] = anova1(ystat,grp);
    if p < 0.05
        c = multcompare(stats);
        pause
    end
    
    bar(y_mean,'c')
    hold on
    errorbar(y_mean,y_std,'k.')
    xlabel('Strain rate')
    xticklabels({'low','med','high'})
    ylabel(['$' name{m} '~~' units{m} '$'])
    title(['ANOVA test: p = ' num2str(p)]);
    
    print(['Q4_' meas{m}],'-dmeta') 
    
    pause
    close all
end


end