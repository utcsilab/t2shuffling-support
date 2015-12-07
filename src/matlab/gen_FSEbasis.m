function [U, X, T1vals, T2vals, TE, e2s] = gen_FSEbasis(N, angles, ETL, e2s, TE, T1vals, T2vals, verbose)
%gen_FSEbasis Generate a basis for a range of T1 and T2 values based on
%SVD.
%
% Inputs:
%  N -- maximum number of T2 signals to simulate
%  angles (deg) -- flip angle train in degrees
%  ETL -- echo train length
%  e2s -- initial echoes to skip
%  TE (s) -- echo spacing
%  T1vals (s) -- array of T1 values to simulate
%  T2vals (s) -- array of T2 values to simulate
%  verbose -- print verbose output
%
% Outputs:
%  U -- temporal basis based on PCA
%  X -- [T, L] matrix of simulated signals
%  T1vals (s) --  T1 values simulated in X
%  T2vals (s) -- T2 values simulated in X
%  TE (s) -- echo spacing simulated in X
%  e2s -- number of initial skipped echoes

if nargin < 4 || isnan(e2s)
    e2s = 4;
end
if nargin < 5 || isnan(TE)
    TE = 5.568e-3;
end
if nargin < 6 || any(isnan(T1vals))
    T1vals = [500 700 1000 1800]*1e-3;
end
if nargin < 7 || any(isnan(T2vals))
    T2vals = linspace(20e-3, 800e-3, N);
end
if nargin < 8
    verbose = false;
end

% randomly choose T2 values if more than N are given
if length(T2vals) > N
    idx = randperm(length(T2vals));
    T2vals = T2vals(idx(1:N));
end

angles_radian = angles*pi/180;
T = length(angles);

if nargin < 3 || isnan(ETL)
    ETL = T - e2s - 1;
end

LT1 = length(T1vals);
LT2 = length(T2vals);

X0 = zeros(T, LT2, LT1);

for ii=1:LT2
    T2 = T2vals(ii);
    for jj=1:LT1
        T1 = T1vals(jj);
        X0(:,ii,jj) = real(FSE_signal(angles_radian, TE, T1, T2)); % keep real value only
    end
    
    if verbose
        disp([num2str(ii), '/', num2str(LT2)]);
    end
end

X0 = reshape(X0, T, []);
keep = (1+e2s:e2s+ETL); % don't count last echo
X = X0(keep,:);
[U, ~, ~] = svd(X, 'econ');

end