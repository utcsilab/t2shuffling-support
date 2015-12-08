function [ masks, y_echoes, z_echoes, sp_mask ] = gen_t2shuffling_mask(options)
%gen_t2shuffling_mask Generate k-t sampling pattern for T2 Shuffling
%
% Inputs:
%  options -- struct contanining variables defining the sampling pattern:
%    options.dims [ny, nz] -- dimensions of k-space
%    options.accel [Ry, Rz] -- acceleration factor
%    options.ETL -- echo train length
%    options.num_masks -- number of masks to generate
%    options.shuffle -- true to randomly shuffle echo train ordering
%    options.e2s -- number of initial skipped echoes
%    options.cut_corners -- circular k-space coverage
%    options.VD -- controls degree of variable density sampling
%    options.mask_cal_size -- fully sampled calibration region per mask
%    options.ran_seed -- used to seed RNG for Poisson Disc sampling
%
% Outputs:
%  masks [ny, nz, ETL] -- k-t sampling pattern
%  y_echoes, z_echoes [Ntr, ETL] -- phase encodes to be sampled at each TE
%  sp_mask [ny, nz] --  binary mask of phase encodes that are acquired


%% args
if isfield(options, 'dims')
    dims = options.dims;
else
    dims = [256 256];
end

if isfield(options, 'accel')
    accel = options.accel;
else
    accel = [2, 2];
end

if isfield(options, 'ETL')
    ETL = options.ETL;
else
    ETL = 82;
end

if isfield(options, 'num_masks')
    num_masks = options.num_masks;
else
    num_masks = 4;
end

if isfield(options, 'shuffle')
    shuffle = options.shuffle;
else
    shuffle = true;
end

if isfield(options, 'e2s')
    e2s = options.e2s;
else
    e2s = 2;
end

if isfield(options, 'cut_corners')
    cut_corners = options.cut_corners;
else
    cut_corners = true;
end

if isfield(options, 'VD')
    VD = options.VD;
else
    VD = 3;
end

if isfield(options, 'mask_cal_size')
    mask_cal_size = options.mask_cal_size;
else
    mask_cal_size = 12;
end

if isfield(options, 'ran_seed');
    ran_seed = options.ran_seed;
else
    ran_seed = 1251046800;  % Aug 23, 2009 10am
end


% internal parameters
cal_size = 24;

% defs
ny = dims(1);
nz = dims(2);

Ry = accel(1);
Rz = accel(2);

T = ETL - e2s;

%%

% main spatial mask
if (Ry > 1 || Rz > 1)
    sp_mask = vdPoisMex(ny, nz, 300, 300, Ry, Rz, cal_size, double(cut_corners), VD, ran_seed);
else
    sp_mask = ones(ny, nz);
    if cut_corners
        [ZZ, YY] = meshgrid(linspace(-1, 1, nz),linspace(-1, 1, ny));
        R = sqrt((ZZ/1).^2+(YY/1).^2);
        sp_mask(R>1) = 0;
    end
end


% generate center-out ordering to start
[y_echoes_full, z_echoes_full] = gen_echoes(T, sp_mask);
Ntr = size(y_echoes_full, 1);


if num_masks == 1
    y_echoes_r = y_echoes_full;
    z_echoes_r = z_echoes_full;
    
    if shuffle
        for ii=1:Ntr
            idx = (1:T);
            perm_idx = idx(randperm(length(idx)));
            y_echoes_r(ii, 1:T) = y_echoes_r(ii, perm_idx);
            z_echoes_r(ii, 1:T) = z_echoes_r(ii, perm_idx);
        end
    end
else
    % make num_masks masks, each one with M points
    M  = T / num_masks;

    y_echoes_r = zeros(Ntr, T);
    z_echoes_r = zeros(Ntr, T);
        
    fudge = 1.1;
    R = sqrt(ny * nz * pi / (4 * fudge * Ntr * M));
    
    idx_mm = reshape(1:T, M, num_masks);
    
    for mm=1:num_masks
        
        ran_seed = ran_seed + 1;
        cen_only = zpad(ones(mask_cal_size), ny, nz);
        mask_m = vdPoisMex(ny, nz, 300, 300, R, R, mask_cal_size, double(cut_corners), VD, ran_seed);
        
        % prune mask until M * Ntr points remain     
        idx = find(mask_m ~= 0);
        idx = idx(randperm(length(idx)));
        ii = 1;
        while sum(mask_m(:)) > M * Ntr
            if cen_only(idx(ii)) == 0
                mask_m(idx(ii)) = 0;
            end
            ii = ii + 1;
        end    
        
        [y_echoes_m, z_echoes_m] = gen_echoes(M, mask_m);
        
        % randomly permute the echo trains
        if shuffle
            for ii=1:Ntr
                idx = (1:M);
                perm_idx = idx(randperm(length(idx)));
                y_echoes_m(ii, 1:M) = y_echoes_m(ii, perm_idx);
                z_echoes_m(ii, 1:M) = z_echoes_m(ii, perm_idx);
            end
        end
        
        % assign the M'th piece of the echo trains
        y_echoes_r(:, idx_mm(:, mm)) = y_echoes_m; 
        z_echoes_r(:, idx_mm(:, mm)) = z_echoes_m;
    end
end


% add echoes2skip
y_echoes_e2s = y_echoes_full(:, 1:e2s);
z_echoes_e2s = z_echoes_full(:, 1:e2s);
    
% combine
y_echoes = cat(2, y_echoes_e2s, y_echoes_r);
z_echoes = cat(2, z_echoes_e2s, z_echoes_r);
      
% build mask from echo trains
masks = zeros(ny,nz,ETL);

for ii=1:ETL
    yi = y_echoes(:,ii);
    zi = z_echoes(:,ii);
    
    idx_yi = find(~isnan(yi));
    yi = yi(idx_yi);
    zi = zi(idx_yi);
    
    idx_zi = find(~isnan(zi));
    yi = yi(idx_zi);
    zi = zi(idx_zi);
    
    for jj=1:length(yi)
        masks(yi(jj) + ny/2, zi(jj) + nz/2, ii) = 1;
    end
end

end

