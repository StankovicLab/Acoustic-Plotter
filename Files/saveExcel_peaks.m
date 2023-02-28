function saveExcel_peaks(path, fn, list, details, threshold)
% function for saving peak data as an excel. 
%
% explorted data will include peaks and nodes as well as thresholds
%
% saveExcel_peaks(fn, details, thresh)
% fn = [array] name of experiment
% details = [struct] details structure created by collectdetailsARF function
% thresh = [struct] threshold structure 

% define special characters to be removed
specialChar = ['-', '+', '=', '!', '@', '#', '$', '%', '^', '&',...
    '*', '(', ')', '[', ']', '{', '}', ':', ';', '"', ',', '.',...
    '<', '>', '/', '?', '\', '|', '~', '`'];

% find all frequencies used
f = [];
for i = 1:length(threshold)
    f = [f, threshold(i).freq];
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

% catch, make sure atleast some files are selected
if ~isempty(selected)
    % select folder and file name to save to
%     [file,path] = uiputfile([fn, '_peaks.xlsx']);
    [file,path] = uiputfile(fullfile(path, [fn, '_peaks.xlsx']));

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
end


%% save data

% set up constants
multA = 10^9; % to make in nV
col = {'Levels', 'Peak to Peak', 'P1 Latency','P1 Amplitude','N1 Latency','N1 Amplitude',...
                                'P2 Latency','P2 Amplitude','N2 Latency','N2 Amplitude',...
                                'P3 Latency','P3 Amplitude','N3 Latency','N3 Amplitude',...
                                'P4 Latency','P4 Amplitude','N4 Latency','N4 Amplitude',...
                                'P5 Latency','P5 Amplitude','N5 Latency','N5 Amplitude'};

% catch, make sure atleast some files are selected
if ~isempty(selected)

    % find the total number of animals x frequencies that have to be saved
    % this number is needed to keep track of saving progress
    tot = length(details) * length(freqstr) + 1;

    % loop through each selected mouse and give each it's own sheet
    count = 1;
    for i = selected

        clearvars -except i saveName details threshold specialChar fn w count tot selected filt fbounds col multA

        % initallize dat cell
        dat = cell(12, length(col));

        % gather all info for header
        dat(1:7,1:2) = {'ID', details(i).ID;... %ID
            'ref1', details(i).ref1;... %ref1
            'ref2', details(i).ref2;... %ref2
            'data saved as', 'nV';...
            'original collected on', datetime(details(i).date, 'Format', 'default');...  %original save date
            'saved on', datetime('today', 'Format', 'default');... % date
            'notes', details(i).notes}; %notes
        dat(10,1) = {'PEAKS'};

        % loop through frequencies write data to excel
        for j = 1:length(details(i).freqlist)
        
            %extract info
            levels = details(i).(['Freq', num2str(j)]).levels;
            peaks = details(i).(['Freq', num2str(j)]).peaks;

            % write frequency and threshold
            dat(size(dat,1)+1,:) = [details(i).freqlist(j),{'Threshold = '},{num2str(threshold(i).thresh(j))},...
                {'Original File'}, details(i).originalFN(j),...
                cell(1,size(dat,2)-5)];

            % write column headers
            dat(size(dat,1)+1,:) = col;

            %loop through levels and add info to dat
            for k = flip(1:length(levels))

                % set constants
                pos = size(dat,1)+1;
                [~, idx] = min(abs(levels - threshold(i).thresh(j)));
                if k >= idx
                    multL = 1;
                    multA1 = multA;
                else
                    multL = nan;
                    multA1 = nan;
                end

                dat(pos,:) = cell(1,size(dat,2));

                dat(pos,1) = {num2str(levels(k))}; % level
                dat(pos,2) = {num2str(abs(peaks.pks(k,1,1) - peaks.nodes(k,1,1))*multA1)}; % peak to peak

                dat(pos,3) = {num2str(peaks.pks(k,2,1)*multL)}; % P1 Latancy
                dat(pos,4) = {num2str(peaks.pks(k,1,1)*multA1)}; % P1 Amplitude
                dat(pos,5) = {num2str(peaks.nodes(k,2,1)*multL)}; % N1 Latancy
                dat(pos,6) = {num2str(peaks.nodes(k,1,1)*multA1)}; % N1 Amplitude

                dat(pos,7) = {num2str(peaks.pks(k,2,2)*multL)}; % P2 Latancy
                dat(pos,8) = {num2str(peaks.pks(k,1,2)*multA1)}; % P2 Amplitude
                dat(pos,9) = {num2str(peaks.nodes(k,2,2)*multL)}; % N2 Latancy
                dat(pos,10) = {num2str(peaks.nodes(k,1,2)*multA1)}; % N2 Amplitude

                dat(pos,11) = {num2str(peaks.pks(k,2,3)*multL)}; % P3 Latancy
                dat(pos,12) = {num2str(peaks.pks(k,1,3)*multA1)}; % P3 Amplitude
                dat(pos,13) = {num2str(peaks.nodes(k,2,3)*multL)}; % N3 Latancy
                dat(pos,14) = {num2str(peaks.nodes(k,1,3)*multA1)}; % N3 Amplitude

                dat(pos,15) = {num2str(peaks.pks(k,2,4)*multL)}; % P4 Latancy
                dat(pos,16) = {num2str(peaks.pks(k,1,4)*multA1)}; % P4 Amplitude
                dat(pos,17) = {num2str(peaks.nodes(k,2,4)*multL)}; % N4 Latancy
                dat(pos,18) = {num2str(peaks.nodes(k,1,4)*multA1)}; % N4 Amplitude

                dat(pos,19) = {num2str(peaks.pks(k,2,5)*multL)}; % P5 Latancy
                dat(pos,20) = {num2str(peaks.pks(k,1,5)*multA1)}; % P5 Amplitude
                dat(pos,21) = {num2str(peaks.nodes(k,2,5)*multL)}; % N5 Latancy
                dat(pos,22) = {num2str(peaks.nodes(k,1,5)*multA1)}; % N5 Amplitude

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

        % write to excel
        writecell(dat, saveName, 'Sheet', sheet)

    end

    % close waitbar window
    close(w)

end

return
