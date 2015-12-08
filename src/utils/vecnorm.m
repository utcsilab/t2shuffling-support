function [ y ] = vecnorm( A, arg )
%vecnorm Compute norm of each column vector in a matrix
%   arg: second argument passed to norm function (default: 2)

if nargin < 2
    arg = 2;
end

% avoid for loop if possible
if isnumeric(arg) && (abs(arg) ~= Inf)
    y = sum(abs(A).^arg,1).^(1/arg);
else
    [~, ny] = size(A);
    y = zeros(1, ny);
    for ii=1:ny
        a = A(:,ii);
        y(ii) = norm(a,arg);
    end
end

end

