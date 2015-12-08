function [ alpha ] = temporal_adjoint(im, Phi, flatten)
% temporal_adjoint orthognal projection according to:
%   alpha = Phi' im
%
%    im: [I1, I2, ..., In, T] Fully sampled image at each echo time (oracle)
%    Phi: [T, K] orthogonal basis operator
%    alpha: [I1, I2, ..., In,  K] image coefficients for basis elements
%  I1, I2, ..., In are image/coil/other dimensions
%  T is echo train length (number of echo times)
%  K is the number of basis coefficients

if nargin < 3
    flatten = false;
end

dims = size(im);
[T, K] = size(Phi);
L = prod(dims(1:end-1));

dims2 = dims;
dims2(end) = K;

% compute coefficients, alpha, of orthogonal projection
coeffs =Phi' * reshape(im, L, T).';

if flatten
    alpha = coeffs;
else
    alpha = reshape(coeffs.', dims2);
end

end
