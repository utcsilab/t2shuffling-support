function [ out ] = psf_1d(my_T2vals, ETL, TE, randshuffle, normalize_psfs, zoom, fignum)
%psf_1d Plot the 1D Point Spread Function (PSF) of the view ordering
%
% Inputs:
%  my_T2vals (array in s) -- T2 values to display
%  ETL -- echo train length
%  TE (s) -- echo spacing
%  randshuffle (true/false) -- Randomly shuffle if true
%  normalize_psf (true/false) -- Normalize each PSF
%  zoom (true/false) -- Zoom in for plot
%  fignum -- figure number
%
%
% Outputs:
%  out -- always returns zero

if (zoom)
    Nover = 20;
    xlimval = [-4,4];
else
    Nover = 1;
    xlimval = [-128,128];
end

M = length(my_T2vals);

if nargin < 7
    ff = 1;
else
    ff = fignum;
end

Tp = 1*ETL;

echo_times = TE:TE:TE*ETL;

sigs = zeros(M, ETL);


for jj=1:M
    T2 = my_T2vals(jj);
    for ii=1:ETL
        sigs(jj, ii) = exp(-echo_times(ii)/T2);
    end
end


%%
% simulate directly in kspace
% Nover = 20;
Nunder = 1;
N = 4*Tp; %at least 2*Tp and multiple of Tp

sigs2 = zeros(M, N/Nunder);
FWHM = zeros(M, 1);

%% generate mask
mask_idx = [reshape(N/2:-1:1,[],Tp); reshape(N/2+1:N,[],Tp)];
if randshuffle
    L = floor(randshuffle*(Tp));
    for i=1:N/Tp
        for m=0:(Tp-L)
            tmp = mask_idx(i,m+1:m+L);
            tmp = tmp(randperm(length(tmp)));
            mask_idx(i,m+1:m+L) = tmp;
        end
    end
end
mask = zeros(N,Tp);
for i=1:Tp
  mask(mask_idx(:,i),i) = 1;
end
%%

for jj=1:M
    
    sig = sigs(jj,:);
    sig_ksp = ones(N, Tp).*repmat(sig, N, 1);
    sig2_ksp = sum(sig_ksp.*mask,2);
%     sig2_ksp = sig_ksp(:,1);
    
    sig3_ksp = zpad(sig2_ksp, Nover*N, 1);
    sig3 = crop(ifftc(sig3_ksp,1), N/Nunder, 1);
    
    sigs2(jj,:) = abs(sig3);

    
    fwhm1 = find(sigs2(jj,:) > max(sigs2(jj,:))/2, 1, 'first');
    fwhm2 = find(sigs2(jj,:) > max(sigs2(jj,:))/2, 1, 'last');
    FWHM(jj) = fwhm2 - fwhm1 + 1;
end

%%

leg_str = cell(M, 1);
for jj=1:M
    leg_str{jj} = sprintf('T2 = %d ms\n', my_T2vals(jj)*1000);
end


figure(ff);
x_axis = (-N/Nunder/2:N/Nunder/2-1)/Nover;
if normalize_psfs
    sigs3 = sigs2 ./ repmat(max(sigs2, [], 2), 1, length(x_axis));
else
    sigs3 = sigs2;
end
plot(x_axis, (sigs3), 'linewidth', 4);

xlim(xlimval)
legend(leg_str);
if normalize_psfs
    ylim([0, 1]);
end
xlabel('Position (pixels)');
ylabel('Signal');
% set(gca, 'XTick', [])
faxis(gca, 40)

out = 0;

end

