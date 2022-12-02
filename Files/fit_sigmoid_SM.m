function [P, yFit, delta] = fit_sigmoid_SM(X, Y)
% function to fit sigmoid to threshold vs level data, curtesy of Suthakar & Liberman 2019
% 
% [P, yFit, delta] = fit_sigmoid_SM(X, Y)
% X = [double] array of the x axis (levels)
% Y = [double] array of the y axis (thresholds)
%
% P = [double] array of equation coefficients: P(1) min, P(2) max, P(3) midpoint, P(4) slope
% yFit = [double] y values of a best fit line
% delta = [double] array of fit error relative to Y (original data)

X = X(:);
Y = Y(:);

a = max(Y);
% xh = mean(X);
[~, kmn] = min(abs(Y - range(Y)/2));
xh = X(kmn);
b = range(Y)/range(X) * 4 / a;
c = b * xh;
Pinit = [b c];
LB = [];
UB = [];

opt = optimset('MaxFunEvals', 4e4, 'MaxIter',4e4, 'Display', 'off');
% opt = optimset('MaxFunEvals', 4e4, 'MaxIter',4e4);

fh = @(p,x)Fsigmoid(p,x,Y);

[P, resNorm, residual] = lsqcurvefit(fh, Pinit, X, Y, LB, UB, opt);

yFit = Fsigmoid(P, X, Y); % create fit, so we have it.

[a,b,c,d] = compute_params(P, X, Y);
P = [a, b, c, d];

%find prediction interval, if error make delta nan
try
    [beta,R,~,CovB,~] = nlinfit(X,Y,fh,P);
    [~,delta] = nlpredci(fh,X,beta,R,'Covar',CovB);
catch
    delta = nan;
end

% figure; hold on
% plot(X, Y, 'ok', 'markersize', 6, 'markerfacecolor', 'k')
% plot(X, yFit, 'b')
% plot(X, Ypred+delta, 'r--')
% plot(X, Ypred-delta, 'r--')


%--------------------------------------------------------------------------
function [a,b,c,d] = compute_params(P, X, Y)
b = P(1);
c = P(2);
u = 1 ./ (1 + exp(c)*exp(-b*X));

lincoeffs = [u ones(size(X))] \ Y;
a = lincoeffs(1);
d = lincoeffs(2);

%--------------------------------------------------------------------------
function F = Fsigmoid(P, X, Y)
[a,b,c,d] = compute_params(P, X, Y);
u = 1 ./ (1 + exp(c)*exp(-b*X));
F = a * u + d;

%--------------------------------------------------------------------------
