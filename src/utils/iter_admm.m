function [ history ] = iter_admm(x_ref, iter_ops, llr_ops, lsqr_ops, Aop, b, callback_fun )
%iter_admm ADMM algorithm for solving locally low rank regularization:
%
% \min_x 0.5 * || y - Ax ||_2^2 + lambda * sum_r || R_r(x) ||_*  --- (1)
%   where R_r extracts a block from x around position r
%
% Inputs:
%  x_ref -- pointer to solution to (1), with result stored in x_ref.data 
%  iter_ops.rho -- rho augmented lagrangian parameter for ADMM
%  iter_ops.max_iter -- maximum number of iterations
%  iter_ops.objfun -- handle to objection function, J(x, sv, lambda)
% 
%  llr_ops.lambda -- regularization parameter for LLR
%  llr_ops.block_dim [Wy, Wz] -- block size for LLR
%
%  lsqr_ops.max_iter -- maximum number of iterations for LSQR within ADMM
%  lsqr_ops.tol -- tolerance
%
%  Aop -- function handle for A'*A*x, Aop(x)
%  b -- adjoint of data, A'*y
% 
%  callback_fun -- execute  callback_fun(x) at the end of each iteration
%
% Outputs:
%  history -- struct of history/statistics from the optimization

if nargin < 6
    use_callback = false;
else
    use_callback = true;
end

x_ref.data = zeros(size(b));

x = x_ref.data;
z = zeros(size(x));
u = zeros(size(x));

rho = iter_ops.rho;
max_iter = iter_ops.max_iter;
objfun = iter_ops.objfun;

lambda = llr_ops.lambda;
block_dim = llr_ops.block_dim;

ABSTOL = 1e-4;
RELTOL = 1e-2;

abserr = sqrt(numel(b)) * ABSTOL;

fprintf('%3s\t%10s\t%10s\t%10s\t%10s\t%10s\t%10s\n', 'iter', ...
    'lsqr iters', 'r norm', 'eps pri', 's norm', 'eps dual', 'objective');

tic;

for ii=1:max_iter
      
    % update x using LSQR. the operator may change if rho changes
    AHA_lsqr = @(a) vec(rho * reshape(a, size(b)) + Aop(reshape(a, size(b)))); % for lsqr
    [a, ~, ~, lsqr_nitr] = symmlq(AHA_lsqr, b(:) + rho * (z(:) - u(:)), ...
        lsqr_ops.tol, lsqr_ops.max_iter, [], [], x(:)); 
    x = reshape(a, size(b));

    % update z using LLR singular value thresholding
    z_old = z;
    xpu = x + u;
    [z, s_vals] = llr_thresh(xpu, lambda / rho, block_dim);
    
    % update u
    u = xpu - z;
    
    % record
    history.objval(ii) = objfun(x, s_vals, lambda);
    history.lsqr_nitr(ii) = lsqr_nitr;
    history.r_norm(ii) = norm_mat(x - z);
    history.s_norm(ii) = norm_mat(-rho * (z - z_old));
    history.eps_pri(ii) = abserr + RELTOL * max(norm(x(:)), norm(z(:)));
    history.eps_dual(ii) = abserr + RELTOL * norm_mat(rho * u);
    
    fprintf('%3d\t%10d\t%10.4f\t%10.4f\t%10.4f\t%10.4f\t%10.2f\n', ii, ...
        sum(history.lsqr_nitr), history.r_norm(ii), history.eps_pri(ii), ...
        history.s_norm(ii), history.eps_dual(ii), history.objval(ii));
    
    if use_callback
        callback_fun(x);
    end
    
    % early stopping condition
    if (history.r_norm(ii) < history.eps_pri(ii)) && (history.s_norm(ii) < history.eps_dual(ii))
        history.nitr = ii;
        break;
    end
    
    x_ref.data = x;
end
t2 = toc;

history.nitr = ii;
history.run_time = t2;

end

