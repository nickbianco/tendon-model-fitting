function [sdat] = sampledata(datapath)

sdat = struct;
sampdata = xlsread(fullfile(datapath,'sampledata.xlsx'));

cond = {'control','static','dynamic'};

for c = 1:length(cond)
    
    switch cond{c}
        case 'control'
            row = [1 2 3];
        case 'static'
            row = [7 8 9];
        case 'dynamic'
            row = [13 14 15];
    end
    
    for s = 1:3
        samp = ['S' num2str(s)];
        sdat.(cond{c}).(samp).m     = sampdata(row(s),2); % mg
        sdat.(cond{c}).(samp).lo    = sampdata(row(s),3); % mm
        sdat.(cond{c}).(samp).w     = sampdata(row(s),4); % mm
        sdat.(cond{c}).(samp).t     = sampdata(row(s),5); % mm
        sdat.(cond{c}).(samp).Aden  = sampdata(row(s),6); % mm^2
        sdat.(cond{c}).(samp).Aell  = sampdata(row(s),7); % mm^2
    end
    
end

end