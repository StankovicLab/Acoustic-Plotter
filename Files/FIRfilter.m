function [filtered delay] = FIRfilter(signal, order, sr, fc)
% filters the signal with a FIR filter of determined order and cutting
% frequency with defined sampling rate (rate must be an integer)
% a = signal
% order = filter order
% sr = sampling rate
% fc = cutoff frequencies, should be an array with 2 variables.  nans used to determine if high/low/bandpass
% cutoffs but be integers and cannot be 0 or inf
% [#, #] = bandpass
% [#, nan] = highpass
% [nan, #] = lowpass
%
% filtered = output signal, the filtered output array is shorter than the input
%                     signal to account for the delay caused by the FIR filter algorithm

if isnan(fc(1)) && isnan(fc(2))
    filtered = signal;
else
    if ~isnan(fc(1)) && ~isnan(fc(2))
        type = 'bandpass';
        freq = fc;
    elseif ~isnan(fc(1)) && isnan(fc(2))
        type = 'high';
        freq = fc(1);
    elseif isnan(fc(1)) && ~isnan(fc(2))
        type = 'low';
        freq = fc(2);
    end

    % Normalize cutoff frequency (wrt Nyquist frequency)
    nyq_freq = sr / 2;
    cutoff_norm = freq / nyq_freq;


    % Create lowpass FIR filter through a direct approach: provide
    % (normalized) cutoff frequency and filter order (assumed as known).
    % fir1 takes care of designing the filter by imposing the constraints in
    % the frequency domain and transforming back to time using a given window
    % (the dafault used here is the Hamming window).
    % For more advanced requirements see e.g. firpmord and firpm
    % NOTE: fir1, firpmord and firpm all require Signal Processing Toolbox
    fir_coeff = fir1(order, cutoff_norm, type);

    % Filter the signal with the FIR filter
    filtered = filter(fir_coeff, 1, signal(~isnan(signal)));
    delay = mean(grpdelay(fir_coeff,length(signal(~isnan(signal))),sr));
    filtered = [filtered(delay+1:end), nan(1, delay)];

end

end