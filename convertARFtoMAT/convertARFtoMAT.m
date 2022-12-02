% Use this script to quickkly convert multiple .arf file created by BioSigRz (TDT)
% to matlab files to later analysis by AcousticPlotter
% 
% Created by Stephen McInturff 2022 
% part of of the Stankovic Lab
% Otolaryngology Department, Stanford University 

clear all
close all
clc

% pick ARF files to convert
[file,path] = uigetfile('*.arf', 'Select one or more MAT files', 'C:\Users\Steve\Documents\Data', 'MultiSelect', 'on');

% make sure file and path are cells
if ~iscell(file)
    if file == 0
        file = {};
    else
        file = {file};  
    end
end

% catch to make sure a file was choosen, otherwise do nothing
if ~isempty(file)

    for i = 1:length(file)

        clearvars -except file path i
        
        % extract data from ARF file
        data = arfread_SM(fullfile(path, file{i}));

        % write the experiment name at top
        fn =  strrep(file{i}, '.arf', '');

        % find all ABR and DPOAEs trials

        selectedDPOAE = [];
        selectedABR = [];

        % make list to be propogated in ListBox by looping through each group
        for j = 1:length(data.groups)

            % make sure there was atleast 1 rep in the group
            if data.groups(j).nrecs > 0
                % figure out if its an ABR or DPOAE file
                % The x-axis of DPOAE files is in frequency but BioSigRx save it as dur_ms
                % this results in a dur_ms of 97656 ms which is an
                % unrealistic duration for an ABR (>1.5 hours) so therefor must be a DPOAE
                if unique(round([data.groups(j).recs.dur_ms])) > 90000
                    selectedDPOAE = [selectedDPOAE, j]; % DPOAE
                else
                    selectedABR = [selectedABR, j]; % ABR
                end
            end
        end

        % create details struct, has waveform data as well to pass to next GUI
        % DPOAEs
        if ~isempty(selectedDPOAE)
            details = collectdetailsARF(data.groups(selectedDPOAE), fn, 'DPOAE');
            thresh = makeThreshStruct(details);

            disp(['SAVING ', fullfile(path,strrep(file{i}, '.arf', '_DPOAE.mat'))])
            save(fullfile(path,strrep(file{i}, '.arf', '_DPOAE.mat')), 'details', 'thresh', '-v7.3')            
        end

        % ABRs
        if ~isempty(selectedABR)
            details = collectdetailsARF(data.groups(selectedABR), fn, 'ABR');
            thresh = makeThreshStruct(details);

            disp(['SAVING ', fullfile(path,strrep(file{i}, '.arf', '_ABR.mat'))])
            save(fullfile(path,strrep(file{i}, '.arf', '_ABR.mat')), 'details', 'thresh', '-v7.3')
        end

    end
end

%% function

function thresh = makeThreshStruct(details)

    for i = 1:length(details)
        % fill in frequency info
        thresh(i).freq = details(i).frequencies;
        % loop through frequencies
        for j = 1:length(thresh(i).freq)
            % set default threshold to -inf, may change later if criteria met
            thresh(i).temp(j) = -inf;
            thresh(i).thresh(j) = -inf;
            thresh(i).user(j) = 0;
        end
    end

end