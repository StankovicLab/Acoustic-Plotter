function details = collectdetailsARF(data, fn, type)
% function to extract details and waveforms from data
% 
% details = rewriteTxt(data, type)
% data = [struct] this is a structure of the selected groups extracted from the arf file
% type = [array] is this an ABR or DPOAE
%
% details = [struct] output structure of all necessary information

% loop through all mice to fill up structs
for i = 1:length(data)

    % make info struc of all important information, catching to make sure the field isn't empty
    details(i).type = type;
    details(i).ID = [];
    if sum(double(data(i).ID)) ~= 0
        details(i).ID = data(i).ID;
    end
    details(i).ref1 = [];
    if sum(double(data(i).ref1)) ~= 0
        details(i).ref1 = data(i).ref1;
    end
    details(i).ref2 = [];
    if sum(double(data(i).ref2)) ~= 0
        details(i).ref2 = data(i).ref2;
    end
    details(i).notes = [];
    if sum(double(data(i).memo)) ~= 0
        details(i).notes = data(i).memo;
    end
    details(i).originalFN = [fn, '.arf'];
    details(i).nrecs = data(i).nrecs;
    details(i).date = datetime(data(i).recs(1).grp_d, 'format', 'MMM d, yyyy');

    if strcmp(type, 'ABR')
        details(i).frequencies = unique([data(i).recs.Var1]);
    else
        details(i).frequencies = unique([data(i).recs.Var2]);
    end

    % unchanging data
    navgs = [data(i).recs.navgs];
    sampPer_us = [data(i).recs.SampPer_us];
    dur_ms = [data(i).recs.dur_ms];
    npts = [data(i).recs.npts];
    gain = [data(i).recs.gain];

    %if DPOAE file, collect cursor info
    if strcmp(type, 'DPOAE')
        F1 = [data(i).recs.Cur1F];
        F2 = [data(i).recs.Cur2F];
        DP = [data(i).recs.Cur3F];
    end

    % loop through frequencies and extract info
    for j = 1:length(details(i).frequencies)

        % create frequency cell for frequency listbox
        details(i).freqlist{j} = [num2str(round(details(i).frequencies(j))), ' Hz'];

        % find trials that are of current freq and associated levels,
        % different from ABRs and DPOAEs
        if strcmp(type, 'ABR')
            idx = find([data(i).recs.Var1] == details(i).frequencies(j));
            levels = [data(i).recs.Var2]; levels = levels(idx);
        else
            idx = find([data(i).recs.Var2] == details(i).frequencies(j));
            levels = [data(i).recs.Var1]; levels = levels(idx);
        end

        % sort levels from high to low and reorganize idx and levels arrays
        [~,or] = sort(levels);
        levels = levels(or); idx = idx(or);

        details(i).(['Freq', num2str(j)]).frequency = details(i).frequencies(j);
        details(i).(['Freq', num2str(j)]).levels = levels;
        details(i).(['Freq', num2str(j)]).indexes = idx;
        details(i).(['Freq', num2str(j)]).navgs = navgs(idx);
        details(i).(['Freq', num2str(j)]).gain = unique(gain(idx));
        details(i).(['Freq', num2str(j)]).samp_dur = unique(sampPer_us(idx));
        details(i).(['Freq', num2str(j)]).dur_ms = unique(dur_ms(idx));
        details(i).(['Freq', num2str(j)]).npts = unique(npts(idx));
        details(i).(['Freq', num2str(j)]).originalFN = [fn, '.arf'];
        
        % create time array
        samp = unique(sampPer_us(idx));
        % if DPOAE file
        if strcmp(type, 'ABR')
            details(i).(['Freq', num2str(j)]).time = (samp:samp:samp*unique(npts(idx)))/1000;
        else
            details(i).(['Freq', num2str(j)]).time = unique(dur_ms)/unique(npts):unique(dur_ms)/unique(npts):unique(dur_ms);
        end

        % if DPOAE file
        if strcmp(type, 'DPOAE')

            % collect cursor info of F1, F2, and DP
            details(i).(['Freq', num2str(j)]).cur.F1 = unique(F1(idx));
            details(i).(['Freq', num2str(j)]).cur.F2 = unique(F2(idx));
            details(i).(['Freq', num2str(j)]).cur.DP = unique(DP(idx));

            % calculate cursor loctions
            spectra = details(i).(['Freq', num2str(j)]).time;            
            [~, F1_loc] = min(abs(spectra - details(i).(['Freq', num2str(j)]).cur.F1)); 
            details(i).(['Freq', num2str(j)]).cur.F1_loc = F1_loc+1;
            [~, F2_loc] = min(abs(spectra - details(i).(['Freq', num2str(j)]).cur.F2)); 
            details(i).(['Freq', num2str(j)]).cur.F2_loc = F2_loc+1;
            [~, DP_loc] = min(abs(spectra - details(i).(['Freq', num2str(j)]).cur.DP)); 
            details(i).(['Freq', num2str(j)]).cur.DP_loc = DP_loc+1;

        end

        % collect waveform data into matrix
        for k = 1:length(idx)
            details(i).(['Freq', num2str(j)]).waveform(k,:) = data(i).recs(idx(k)).data;
        end
    end
end



return
