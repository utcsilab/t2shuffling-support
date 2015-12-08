function [ A2 ] = dimnorm( A, dim, arg )
%dimnorm Compute norm along direction dim
%   arg: second argument passed to norm function (default: 2)

if nargin < 3
    arg = 2;
end


dims = size(A);
dims2 = dims; dims2(dim) = 1;

ldims = 1:length(dims);

ldims2 = [dim, ldims]; ldims2(dim+1) = [];

B = reshape(permute(A, ldims2), dims(dim), []);
y = vecnorm(B, arg);
A2 = reshape(y, dims2);

end