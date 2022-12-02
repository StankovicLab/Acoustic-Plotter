function thresh = estimate_abr_threshold_SM(wav, level)
% function to estimate thresholds for ABRs using a method based on
% cross-correlation descibed in Suthakar & Liberman 2019
% 
% thresh = estimate_abr_threshold_SM(wav, level)
% wav = [double] matrix of all ABR waveforms for all levels
% type = [double] array of the listed levels
%
% thresh = [struct] output structure of thresholds

warning off

criterion = 0.35;

% wf = wf(1:end/2,:);

xc = NaN(length(level)-1, 1);
for k = 1:length(level)-1,
   tmp = corrcoef(wav(:, k), wav(:, k+1));
   xc(k) = tmp(1,2);
end

level = level(1:end-1);
idx = level > 0;

% sigmoid fit
f = @(p,x) p(1) + (p(2)-p(1)) ./ (1 + 10.^((p(3)-x)*p(4)));
[~, sig_fit, sig_delta] = fit_sigmoid_SM(level, xc);

% power fit
fitresult = fit(level(idx), xc(idx), 'power2');
pwr_fit = fitresult.a * level(idx).^fitresult.b + fitresult.c;
pwr_delta = predint(fitresult,level,0.95,'functional','off');

%decide best method based on RMS
if rms(sig_fit - sig_delta) < rms(pwr_fit - pwr_delta(:,1))
    if find(sig_fit>criterion,1)>1
        thresh = level(find(sig_fit>criterion,1)-1);
    else
        thresh = level(find(sig_fit>criterion,1));
    end
else
    if find(pwr_fit>criterion,1)>1
        thresh = level(find(pwr_fit>criterion,1)-1);
    else
        thresh = level(find(pwr_fit>criterion,1));
    end
end

warning on

return

%% plot, use for debugging
%{
figure;

ax1 = subplot(1,2,1); hold on
plot(level, xc, 'ko', 'MarkerFaceColor', 'k');
plot(level(idx), pwr_fit, 'r-', 'LineWidth', 2);
patch([level(idx); flip(level(idx))]', [pwr_delta(:,1); flip(pwr_delta(:,2))]', 'm', 'EdgeColor', 'none','FaceAlpha',.3);

xlabel('Level (dB SPL)');
ylabel('Correlation coefficient');
title('Power fit')

ax2 = subplot(1,2,2); hold on
plot(level, xc, 'ko', 'MarkerFaceColor', 'k');
plot(level, sig_fit, 'b-', 'LineWidth', 2);
patch([level(idx); flip(level(idx))]', [sig_fit+sig_delta; flip(sig_fit-sig_delta)]', 'c', 'EdgeColor', 'none','FaceAlpha',.3);

xlabel('Level (dB SPL)');
ylabel('Correlation coefficient');
title('Sigmoid fit')


linkaxes([ax1 ax2], 'y')
%}

