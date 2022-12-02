function norm = normalizeScale(wav, sep)
% function to normalize scaling so that waveform heights are optimized to plot 
%
% norm = normalizeScale(wav, sep)
%
% wav = [matrix of doubles] waveforms form of current selections
% sep = [double] defined seperation between waveforms on plot
%
% norm = [double] calculated scaling value for normalization


mn = min(wav(end,:));
mx = max(wav(end,:));

dif = diff([mn, mx]);

norm = (sep*1.2)/dif;

return

