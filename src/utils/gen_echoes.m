function [ y_echoes, z_echoes ] = gen_echoes(T, mask)
%gen_echoes Generate echo trains according to radius/angle in mask
%
% Inputs:
%  T -- echo train length
%  mask -- binary sampling mask
%
% Outputs:
%  y_echoes,z_echoes [Ntr, T] --  phase encode locations per echo train

[ny, nz] = size(mask);
idx = find(mask == 1);
M = ceil(length(idx)/T);
[i, j] = ind2sub(size(mask), idx);
y = i-ny/2; z = j-nz/2;

r2 = sqrt((y/ny).^2 + (z/nz).^2);

[t, r] = cart2pol(y,z);

[~, idx_r] = sort(r2);
r_sort = r(idx_r);
t_sort = t(idx_r);

r_sort(end+1:end+M*T-length(r)) = nan;
t_sort(end+1:end+M*T-length(r)) = nan;
r_shape = reshape(r_sort, M, T);
t_shape = reshape(t_sort, M, T);


for i=1:T
    ts = t_shape(:,i);
    [ts2, idx_t] = sort(ts);
    rs = r_shape(:,i);
    rs2 = rs(idx_t);
    r_shape(:,i) = rs2;
    t_shape(:,i) = ts2;
end

[y, z] = pol2cart(t_shape, r_shape);
y_echoes = round(y);
z_echoes = round(z);

end