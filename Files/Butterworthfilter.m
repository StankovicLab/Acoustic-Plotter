function filtered =Butterworthfilter(a, order, fc)
% filters the signal with a butterworth filter of determined order and cutting frequency
% a = signal
% order = filter order
% fc = cutoff frequencies, should be an array with 2 variables.  nans used to determine if high/low/bandpass
% cutoffs but be integers and cannot be 0 or inf
% [#, #] = bandpass
% [#, nan] = highpass
% [nan, #] = lowpass

if isnan(fc(1)) && isnan(fc(2))
    filtered = a;
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


    fs=25000; %sampling frequency
    [B,A] = butter(order,2*freq/fs, type);
    filtered = filtfilt(B,A,a(~isnan(a)));
end

end