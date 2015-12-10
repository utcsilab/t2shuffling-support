function [ alpha_thresh, s_vals ] = llr_thresh(alpha, lambda, block_dim, randshift)
%llr_thresh Locally Low Rank regularization
%   Implements Locally Low Rank regularization through singular value soft
%   thresholding. Non-overlapping patches are extracted from the image and
%   reshaped into a matrix. Random shifting is applied before/after the
%   reshaping
%
%  Inputs:
%    alpha [ny, nz, K] -- coefficient images with K coefficients
%    lambda -- soft threshold parameter
%    block_dim [Wy, Wz] -- spatial dimensions of image block
%    randshift -- true to perform random shifting
%
%  Outputs:
%     alpha_thresh [ny, nz, K] -- coefficient image after singular value
%        thresholding
%     s_vals [ny / Wy, nz / Wz, K] -- singular values of each block before
%        thresholding
%
%  Notes:
%     The image dimensions should be divisible by the block sizes

if nargin < 3
    Wy = 8; Wz = 8;
else
    Wy = block_dim(1);
    Wz = block_dim(2);
end

if nargin < 4
    randshift = true;
end

[ny, nz, K] = size(alpha);

% reshape into patches
% L = (ny - (Wy - 1)) * (nz - (Wz - 1)); % for sliding
L = ny * nz / Wy / Wz; % for distinct

if randshift
    shift_idx = [randi(Wy), randi(Wz) 0];
    alpha = circshift(alpha, shift_idx);
end

alpha_LLR = zeros(Wy*Wz, L, K);
for ii=1:K
    alpha_LLR(:,:,ii) = im2col(alpha(:,:,ii), [Wy,Wz], 'distinct');
end
alpha_LLR = permute(alpha_LLR, [1 3 2]);
s_LLR = zeros(K, L);

% threshold singular values
for ii=1:L
    [UU, SS, VV] = svd(alpha_LLR(:,:,ii), 'econ');
    s_LLR(:,ii) = diag(SS);
    s2 = SoftThresh(s_LLR(:,ii), lambda);
    alpha_LLR(:,:,ii) = UU*diag(s2)*VV';
end

% reshape into image
alpha_thresh = zeros(size(alpha));
for ii=1:K
    alpha_thresh(:,:,ii) = col2im(alpha_LLR(:,ii,:), [Wy, Wz], [ny, nz], 'distinct');   
end

if randshift
    alpha_thresh = circshift(alpha_thresh, -1 * shift_idx);
end

s_vals = permute(reshape(s_LLR, [K, ny / Wy, nz / Wz]), [2, 3, 1]);

end
