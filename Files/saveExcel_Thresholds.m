function saveExcel_Thresholds(fn, details, thresh, groups)
% function for saving threshold data as an excel. 
%
% explorted data will include waveform data, details about the animal, and
% thresh. Each animal will get it's own sheet
%
% saveExcel_Thresholds(fn, details, thresh, groups)
% fn = [array] name of experiment
% details = [struct] details structure created by collectdetailsARF function
% thresh = [struct] threshold structure 
% groups = [array] group designations


% define special characters to be removed
specialChar = ['-', '+', '=', '!', '@', '#', '$', '%', '^', '&',...
    '*', '(', ')', '[', ']', '{', '}', ':', ';', '"', ',', '.',...
    '<', '>', '/', '?', '\', '|', '~', '`'];

%% save threshold summary on first sheet

% find all frequencies used
f = [];
for i = 1:length(thresh)
    f = [f, thresh(i).freq];
end
f = unique(f);
for i = 1:length(f)
    freqstr{i} = num2str(f(i));
    freq(i) = f(i);
end

% make cell that will be saved
dat = cell(6, length(freq) + 5);

dat(1:2,1:2) = {'Thresholds Summary of experiment', fn;...
    'saved on', date};
dat(5,1) = {'THRESHOLDS'};
dat(6,:) = [{'','ID', 'ref1', 'ref2', 'Freq (Hz)'}, freqstr];

% loop through each mouse and write to excel
for i = 1:length(details)
    pos = size(dat,1)+1;
    dat(pos,:) = [{'',details(i).ID, details(i).ref1, details(i).ref2,'Thresh (dB SPL)'}, cell(1,length(freq))];
    % determine if each frequency was collected, if not make '-'
    for j = 1:length(freq)
        if ismember(freq(j), thresh(i).freq)
            ix = find(freq(j) == thresh(i).freq);
            if length(ix) > 1
                ix = ix(1);
            end
            if ~isnan(thresh(i).thresh(ix))
                dat{pos,j+5} = num2str(thresh(i).thresh(ix));
            else
                dat{pos,j+5} = '-';
            end
        else
            dat{pos,j+5} = '-';
        end
    end
end

%% write groups if variable exists

if exist('groups', 'var')

    % skip a few lines
    dat(size(dat,1)+1:size(dat,1)+2,:) = cell(2,size(dat,2));
    
    % write heading to excel
    dat(size(dat,1)+1,1) = {'GROUPS'};
    
    
    % loop through each groups
    for i = 1:4
    
        % set up headers
        dat(size(dat,1)+2,:) = [{['Group ', num2str(i)], 'ID', 'ref1', 'ref2', 'Freq (Hz)'}, freqstr];
    
    %     writecell([{['Group ', num2str(i)], 'ID', 'ref1', 'ref2', 'Freq (Hz)'}, app.freq], saveName, 'Sheet', 'Thresholds Summary', 'range', ['A', num2str(pos)])
    %     pos = pos+1;
    
        % get index of mice in group
        idx = find(groups == i);
    
        %if there are mice in group, loop through group and save
        if ~isempty(idx)
            for j = idx % determine if line was added to group
                if ~isnan(groups(j))
                    pos = size(dat,1)+1;
                    dat(pos,1:5) = {['Group ', num2str(groups(j))], details(j).ID, details(j).ref1, details(j).ref2,'Thresh (dB SPL)'};
                    % determine if each frequency was collected, if not make '-'
                    for k = 1:length(freq)
                        if ismember(freq(k), thresh(j).freq)
                            ix = find(freq(k) == thresh(j).freq);
                            if length(ix) > 1
                                ix = ix(end);
                            end
                            if ~isempty(ix)
                                dat{pos,k+5} = num2str(thresh(j).thresh(ix));
                            else
                                dat{pos,k+5} = '-';
                            end
                        else
                            dat{pos,k+5} = '-';
                        end
                    end
                end
            end
        end
    end
end

% write whole cell array to Excel
writecell(dat, fn, 'Sheet', 'Thresholds Summary')
            
return
