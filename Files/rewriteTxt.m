function txt = rewriteTxt(details, idx_group, idx_freq)
% function to collect important text information and create a cell to be displayed
%
% txt = rewriteTxt(details, idx_group, idx_freq)
% details = [struct] details structure created by collectdetailsARF function
% idx_group = [double] index of current group
% idx_freq = [double] index of current frequency
%
% txt = [cell] output cell with all information to be vien to textarea.value

txt{1} = ['ID;  ', details(idx_group).ID]; 
txt{2} = ['ref1;  ', details(idx_group).ref1]; 
txt{3} = ['ref2;  ', details(idx_group).ref2];
txt{4} = ['navgs;  ', num2str(unique(details(idx_group).(['Freq', num2str(idx_freq)]).navgs))];  
txt{5} = ['samp_dur;  ', num2str(details(idx_group).(['Freq', num2str(idx_freq)]).samp_dur)];
txt{6} = ['notes;  ', details(idx_group).notes];

return