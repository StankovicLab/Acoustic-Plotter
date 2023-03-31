function saveExcel(path, fn, list, details, thresh, fbounds)
% function for saving data as an excel. 
%
% explorted data will include waveform data, details about the animal, and
% thresh. Each animal will get it's own sheet
%
% saveExcel(fn, details, thresh)
% fn = [array] name of experiment
% details = [struct] details structure created by collectdetailsARF function
% thresh = [struct] threshold structure 

% define special characters to be removed
specialChar = ['-', '+', '=', '!', '@', '#', '$', '%', '^', '&',...
    '*', '(', ')', '[', ']', '{', '}', ':', ';', '"', ',', '.',...
    '<', '>', '/', '?', '\', '|', '~', '`'];

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

% open GUI to select which files to be saved
app = saveSelect;
startfuncmaster(app, list);
if ~isvalid(app)
    return
end
selected = app.selected;
filt = app.filt;
close(app.UIFigure)

% select folder and file name to save to
[file,path] = uiputfile(fullfile(path, [fn, '.xlsx']));

% open waitbar window
w = waitbar(0,'Please Wait, Saving Excel');

% catch to make sure the user choose a file
if sum(file) == 0
    return
end

% make saveName
saveName = fullfile(path, file);

% if file exists and user wanted to replace it, delete original
if isfile(saveName)
    delete(saveName);
end

% save first page of the threshold summary
saveExcel_Thresholds(saveName, details, thresh)

%% save data

% catch, make sure atleast some files are selected
if ~isempty(selected)

    % find the total number of animals x frequencies that have to be saved
    % this number is needed to keep track of saving progress
    tot = length(details) * length(freqstr) + 1;

    % loop through each selected mouse and give each it's own sheet
    count = 1;
    for i = selected

        clearvars -except i saveName details thresh specialChar fn w count tot selected filt fbounds

        % initallize dat cell
        dat = cell(12, length(details(1).Freq1.time)+2);

        % gather all info for header
        dat(1:7,1:2) = {'ID', details(i).ID;... %ID
            'ref1', details(i).ref1;... %ref1
            'ref2', details(i).ref2;... %ref2
            'data saved as', 'Volts';...
            'original collected on', datetime(details(i).date, 'Format', 'default');...  %original save date
            'saved on', datetime('today', 'Format', 'default');... % date
            'notes', details(i).notes}; %notes
        dat(11,1:4) = {'DATA', '', 'Filter', 'none'};
        % write filter information
        if filt
            if ~isnan(fbounds(1)) && ~isnan(fbounds(2))
                dat(11,4:6) = {'BandPass', 'cutoffs', num2str(fbounds)};
            elseif isnan(fbounds(1)) && ~isnan(fbounds(2))
                dat(11,4:6) = {'HighPass', 'cutoff', num2str(fbounds(1))};
            elseif ~isnan(fbounds(1)) && isnan(fbounds(2))
                dat(11,4:6) = {'LowPass', 'cutoff', num2str(fbounds(2))};
            end
        end

        % loop through frequencies write data to excel
        for j = 1:length(details(i).freqlist)


            %extract info
            time = details(i).(['Freq', num2str(j)]).time;
            levels = details(i).(['Freq', num2str(j)]).levels;
            data = details(i).(['Freq', num2str(j)]).waveform;

            % write frequency and threshold
            dat(size(dat,1)+1,:) = [details(i).freqlist(j),{' '},{['Threshold = ', num2str(thresh(i).thresh(j))]},...
                {['samp_dur = ', num2str(details(i).(['Freq', num2str(j)]).samp_dur)]},...
                {'Original File'}, details(i).originalFN(j),...
                cell(1,size(dat,2)-6)];

            % write time or spectrum based on ABR or DPOAE data
            if strcmp(details(i).type, 'ABR')
                dat(size(dat,1)+1,:) = [{'Time [ms]'}, {'nAVG'}, num2cell(time)];
            elseif strcmp(details(i).type, 'DPOAE')
                dat(size(dat,1)+1,:) = [{'Freq [Hz]'}, {'nAVG'}, num2cell(time)];
            else
                dat(size(dat,1)+1,:) = [{'Unknown'}, {'nAVG'}, num2cell(time)];
            end

            %loop through levels and add info to dat
            for k = 1:length(levels)
                Y = squeeze(data(k,:));
                % add filter if selected
                if filt 
                    if all(~isnan(fbounds))
                        Y = Butterworthfilter(Y, 5, [low, high]);
                    end
                end
                dat(size(dat,1)+1,:) = [{[num2str(levels(k)), ' dB SPL']}, {num2str(details(i).(['Freq', num2str(j)]).navgs(k))}, num2cell(Y)];
            end

            % skip a few lines
            dat(size(dat,1)+1:size(dat,1)+2,:) = cell(2,size(dat,2));

            %update waitbar
            w = waitbar(count/(tot),w,'Please Wait, Saving Excel');
            count = count + 1;

        end

        % make sheet name and remove any special characters
        sheet = [num2str(i),'_',details(i).ID, '__', details(i).ref1, '__', details(i).ref2];
        sheet = strrep(sheet, ' ', '');
        sheet(ismember(sheet, specialChar)) = '_';

        % sheet cant be longer than 30 charactors or will through an error
        if length(sheet)>30
            sheet = sheet(1:30);
        end

        % write to excel
        writecell(dat, saveName, 'Sheet', sheet)

    end

    % close waitbar window
    close(w)

end

return
