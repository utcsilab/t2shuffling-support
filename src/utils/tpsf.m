function [ TPSF ] = tpsf(mask, basis, K, patch_size)
%tpsf Generate the transform point spread function (TPSF) image
% from a particular mask and basis
%
% Inputs:
%  mask [nx, ny, T] -- sampling pattern
%  basis [T, T] -- temporal basis
%  K -- temporal subspace size
%  patch_size -- size of point/patch
%
% Outputs:
%  TPSF -- TPSF in the form of an image

if nargin < 4
    patch_size = 7;
end

if patch_size == 1
    single_point = true;
else
    single_point = false;
end

Wx = patch_size;
Wy = patch_size;
[nx, ny, ~] = size(mask);

Phi = basis(:,1:K);

% Temporal projection operator
T_for = @(a) temporal_forward(a, Phi);
T_adj = @(x) temporal_adjoint(x, Phi);

% Fourier transform
F_for = @(x) fft2c(x);
F_adj = @(y) ifft2c(y);

% Sampling mask
P_for = @(y) bsxfun(@times, y, mask);

% Full forward model
AHA = @(a) F_adj(T_adj(P_for(T_for(F_for(a))))); % slightly faster


if single_point
    R = zeros(nx,ny); R(nx/2,ny/2) = 1;
else
    R = zpad(ones(Wx,Wy), nx, ny);
end

TPSF = zeros(nx, ny, K, K);
for ii=1:K    
    a = zeros(nx,ny,K);
    a(:,:,ii) = R;
    TPSF(:,:,ii,:) = AHA(a);
end

end

