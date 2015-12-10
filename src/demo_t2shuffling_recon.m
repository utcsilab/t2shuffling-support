%%%%%%
% This code demonstrates the T2 Shuffling reconstruction
% described in the MRM paper,
% "T2 Shuffling: Sharp, Multi-Contrast, Volumetric Fast Spin-Echo Imaging"
%
% The code is provided to demonstrate the method. It is not optimized
% for reconstruction time
%
% Jonathan Tamir <jtamir@eecs.berkeley.edu>
% Dec 07, 2015
%%
addpath src/utils
%% load data
ksp = sqreadcfl('data/ksp.cfl');
sens1 = sqreadcfl('data/sens.cfl');
bas = sqreadcfl('data/basis.hdr');
mask = sqreadcfl('data/mask.cfl');
im_truth = sqreadcfl('data/imgs.cfl');

% parameters
K = 4;
Phi = bas(:,1:K);
T = 80;
ny = 256;
nz = 256;
nc = 8;

% repmat mask
masks = permute(mask, [1 2 4 3]);

% normalize and repmat sensitivities
sens1_mag = reshape(vecnorm(reshape(sens1, [], nc).'), [ny, nz]);
sens = bsxfun(@rdivide, sens1, sens1_mag); sens(isnan(sens)) = 0;

%% scaling
tmp = dimnorm(ifft2c(bsxfun(@times, ksp, masks)), 3);
tmpnorm = dimnorm(tmp, 4);
tmpnorm2 = sort(tmpnorm(:), 'ascend');
% match convention used in BART
p100 = tmpnorm2(end);
p90 = tmpnorm2(round(.9 * length(tmpnorm2)));
p50 = tmpnorm2(round(.5 * length(tmpnorm2)));
if (p100 - p90) < 2 * (p90 - p50)
    scaling = p90;
else
    scaling = p100;
end
fprintf('\nScaling: %f\n\n', scaling);

ksp = ksp ./ scaling;

%% operators

% ESPIRiT maps operator applied to coefficient images
S_for = @(a) bsxfun(@times, sens, permute(a, [1, 2, 4, 3]));
S_adj = @(as) squeeze(sum(bsxfun(@times, conj(sens), as), 3));
SHS = @(a) S_adj(S_for(a));

% Temporal projection operator
T_for = @(a) temporal_forward(a, Phi);
T_adj = @(x) temporal_adjoint(x, Phi);

% Fourier transform
F_for = @(x) fft2c(x);
F_adj = @(y) ifft2c(y);

% Sampling mask
P_for = @(y) bsxfun(@times, y, masks);masks.*y;

% Full forward model
A_for = @(a) P_for(T_for(F_for(S_for(a))));
A_adj = @(y) S_adj(F_adj(T_adj(P_for(y))));
AHA = @(a) S_adj(F_adj(T_adj(P_for(T_for(F_for(S_for(a))))))); % slightly faster

ksp_adj = A_adj(ksp);

%%
alpha = zeros(ny,nz,K);
alpha_old = alpha;
alpha_y = alpha;

nitr = 200;
tau = 0.95;
lambda = .05;
eps = 1e-3;
block_dim = [8, 8];


tk = 1;

objval = zeros(nitr, 1);
[~, s_vals] = llr_thresh(ksp_adj, 0, block_dim);

objective = @(a, sv, lam) 0.5*norm_mat(ksp - A_for(a))^2 + lambda*sum(sv(:));

fprintf('Objective Value\n');

for ii=1:nitr
        
    r = ksp_adj - AHA(alpha_y);
    
    objval(ii) = objective(alpha, s_vals, lambda);
    fprintf('#It %03d: %f\n', ii, objval(ii));

    [alpha, s_vals] = llr_thresh(alpha_y + tau*r, lambda*tau, block_dim);
    
    % FISTA step
    tkold = tk;
    tk = (1 + sqrt(1 + 4*tkold^2))/2;
    
    alpha_y = alpha + (tkold - 1)/tk * (alpha - alpha_old);
    alpha_old = alpha;
    
end

disp(' ');

%%
im = temporal_forward(alpha, Phi);

disp('rescaling')
im = im * scaling;
%%
fprintf('relative norm with truth: %f\n', relnorm(im, im_truth));
figure(1);
imshow(abs(cat(2,im_truth(:,:,1), im(:,:,1))), []);
title('TE 1 - truth (left) vs. recon (right)');
figure(2);
imshow(abs(cat(2,im_truth(:,:,12), im(:,:,12))), []);
title('TE 12 - truth (left) vs. recon (right)');


