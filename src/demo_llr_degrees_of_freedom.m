%%%%%%
% T2 Shuffling Demo: Compute locally low rank degrees of freedom from a
% T2 Shuffling reconstruction, and perform basic clustering.
%
% Jonathan Tamir <jtamir@eecs.berkeley.edu>
% Jan 04, 2016
%
%%
addpath src/utils

%% parameters
K = 4; % subspace size
Km = 6; % k-means cluster size
block_dim = 10; % LLR block size
tol = 1e-3; % tolerance for computing DOF

%% load image and compute temporal coefficients
recon = squeeze(readcfl('data/knee/recon'));
recon = squeeze(recon(:,:,1,:)); % first map only
bas = squeeze(readcfl('data/knee/bas'));

[ny, nz, T] = size(recon);

% subspace
Phi = bas(:,1:K);

% temporal coefficient images
alpha = temporal_adjoint(recon, Phi);

% Show the temporal coefficient images
figure(1)
imshow(reshape(abs(alpha), ny, []), [])
ftitle('Temporal Coefficient Images');

%% Compute LLR singular values and degrees of freedom

% singular values of each block
[~, s_vals] = llr_thresh(alpha, 0, [block_dim, block_dim], false);

% degrees of freedom of each block
s_vals = imresize(s_vals, 10);
alpha_dof = sum(s_vals > tol * max(s_vals(:)), 3);

figure(2);
imshow(alpha_dof, []), colorbar;
ftitle('LLR Degrees of Freedom');

%% Classify with k-means clustering
IDX = kmeans(reshape(abs(alpha), [], K), Km);
alpha_classes = reshape(IDX, ny, nz);

figure(3);
imshow(alpha_classes, []), colormap('default'), colorbar;
ftitle('K-Means Clustering');
