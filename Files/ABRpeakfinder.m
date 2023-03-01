
%%

% use this code for troubleshooting the ABR part of AcousticPlotter. 

clear all
clc
close all

addpath('FunctionsFolder\')
addpath('FunctionsFolder\GUIs\')

load('C:\Users\stevemci\Box\Stephen McInturff''s Files\PBM\PBM_ABR_round2_Pre_Reorganized.mat')

mouse = 17;
freq = 3;

sr = 1000000/details(mouse).(['Freq', num2str(freq)]).samp_dur;
levels = details(mouse).(['Freq', num2str(freq)]).levels;
dat = details(mouse).(['Freq', num2str(freq)]).waveform;
time = details(mouse).(['Freq', num2str(freq)]).time;


col = ['r', 'y', 'g', 'c', 'b'];

% find peaks of highest
constraints = [1.5, 2.5, 3.5, 4.5, 5.5];
std = 0.5;

[pks,locs,~,ps] = findpeaks(dat(end,:));
locs = time(locs);

for j = 1:5
    pk = pks(locs > constraints(j)-std & locs < constraints(j)+std);
    loc = locs(locs > constraints(j)-std & locs < constraints(j)+std);
    p = ps(locs > constraints(j)-std & locs < constraints(j)+std);

    if length(pk) > 1
        [~, idx] = max(p);
        pk = pk(idx);
        loc = loc(idx);
        p = p(idx);
    end

    master_locs(length(levels),j) = loc;
end


% plot
figure; hold on

spacing = 50*10^-9;

for i = flip(1:length(levels))

    y = dat(i,:);

    plot(time, y + ((i-1) * spacing), 'linewidth', 1, 'color', 'k')

    % find peaks
    [pks,locs,~,ps] = findpeaks(y);
    locs = time(locs);

    for j = 1:5
        
        if i == 8 && j == 4
            master_locs(i,j) = 5.07904;
            [~, idx] = min(abs(time - master_locs(i,j)));
            plot(time(idx), y(idx) + ((i-1) * spacing), 'marker', 'o', 'LineStyle','none', 'markerfacecolor', col(j), 'MarkerEdgeColor', 'k')
        elseif i == 9 && j == 3
            master_locs(i,j) = 3.52256;
            [~, idx] = min(abs(time - master_locs(i,j)));
            plot(time(idx), y(idx) + ((i-1) * spacing), 'marker', 'o', 'LineStyle','none', 'markerfacecolor', col(j), 'MarkerEdgeColor', 'k')
        else
            if i == length(levels)
                a = locs - master_locs(i,j);
            else
                a = locs - master_locs(i+1,j);
            end
            a(a<-0.1) = nan;
            [~, idx] = min(a);
            plot(locs(idx), pks(idx) + ((i-1) * spacing), 'marker', 'o', 'LineStyle','none', 'markerfacecolor', col(j), 'MarkerEdgeColor', 'k')
            master_locs(i,j) = locs(idx);
        end    
    end

end

%% find nodes

[pks,locs,~,ps] = findpeaks(-dat(end,:));
locs = time(locs);

for j = 1:5
    if j < 5
        pk = pks(locs > master_locs(length(levels),j) & locs < master_locs(length(levels),j+1));
        loc = locs(locs > master_locs(length(levels),j) & locs < master_locs(length(levels),j+1));
        p = ps(locs > master_locs(length(levels),j) & locs < master_locs(length(levels),j+1));
    else
        pk = pks(locs > master_locs(length(levels),j) & locs < master_locs(length(levels),j)+2);
        loc = locs(locs > master_locs(length(levels),j) & locs < master_locs(length(levels),j)+2);
        p = ps(locs > master_locs(length(levels),j) & locs < master_locs(length(levels),j)+2);
    end

    if length(pk) > 1
        [~, idx] = max(p);
        pk = pk(idx);
        loc = loc(idx);
        p = p(idx);
    end

    master_nodes(length(levels),j) = loc;
end


for i = flip(1:length(levels))

    y = -dat(i,:);

    % find peaks
    [pks,locs,~,ps] = findpeaks(y);
    locs = time(locs);

    for j = 1:5
        
        if i == length(levels)
            a = locs - master_nodes(i,j);
        else
            a = locs - master_nodes(i+1,j);
        end
        a(a<-0.1) = nan;
        [~, idx] = min(a);
        plot(locs(idx), -pks(idx) + ((i-1) * spacing), 'marker', 's', 'LineStyle','none', 'markerfacecolor', col(j), 'MarkerEdgeColor', 'k')
        master_nodes(i,j) = locs(idx);
    end
end

%% find nodes 2

for i = flip(1:length(levels))

    y = dat(i,:)*-1;

    % find peaks
    [pks,locs,~,ps] = findpeaks(y);
    locs = time(locs);

    for j = 1:5
        if j < 5
            start = master_locs(i,j);
            stop = master_locs(i,j+1);
        else
            start = master_locs(i,j);
            stop = start + 2;
        end

        pk = pks(locs>start & locs<stop);
        loc = locs(locs>start & locs<stop);
        p = ps(locs>start & locs<stop);
        
        [~, idx] = max(p);
        plot(loc(idx), -pk(idx) + ((i-1) * spacing), 'marker', 'd', 'LineStyle','none', 'markerfacecolor', col(j), 'MarkerEdgeColor', 'k')
    end

end

%% plot all peaks

%{
figure; hold on

spacing = 50*10^-9;

for i = flip(1:length(levels))

    y = dat(i,:);

    plot(time, y + ((i-1) * spacing), 'linewidth', 1, 'color', 'k')

    % find peaks
    [pks,locs,~,ps] = findpeaks(y);
    locs = time(locs);

    plot(locs, pks + ((i-1) * spacing), 'marker', 'o', 'LineStyle','none', 'markerfacecolor', 'r', 'MarkerEdgeColor', 'k')


end
%}
