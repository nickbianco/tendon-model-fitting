function [data] = ramp(datapath)

data = struct();

cond = {'control'}; %,'static','dynamic'};
sample = {'S1'}; %,'S2','S3'};

for c = 1:length(cond)
    for s = 1:length(sample)
        filepath = fullfile(datapath,cond{c},sample{s},'raw_data.csv');
        srow = 4;
        rampdata = csvread(filepath,srow,0);
        
        % Get start/end indices for low/high strain rate tests
        low_start = rampdata(1,4)-srow
        low_end = rampdata(1,5)-srow
        high_start = rampdata(1,6)-srow
        high_end = rampdata(1,7)-srow
        
        data.(cond{c}).(sample{s}).low.start = low_start;
        data.(cond{c}).(sample{s}).low.end = low_end;
        data.(cond{c}).(sample{s}).high.start = high_start;
        data.(cond{c}).(sample{s}).high.end = high_end;
        
        % Low strain rate data
        data.(cond{c}).(sample{s}).low.time = rampdata(low_start:low_end,1);
        data.(cond{c}).(sample{s}).low.ext = rampdata(low_start:low_end,2)-rampdata(1,2);
        data.(cond{c}).(sample{s}).low.load = rampdata(low_start:low_end,3);
        
        % High strain rate data
        data.(cond{c}).(sample{s}).high.time = rampdata(high_start:high_end,1);
        data.(cond{c}).(sample{s}).high.ext = rampdata(high_start:high_end,2)-rampdata(1,2);
        data.(cond{c}).(sample{s}).high.load = rampdata(high_start:high_end,3);
                 
    end
end




end