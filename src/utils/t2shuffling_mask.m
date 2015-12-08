%% t2shuffling_mask.m
%
% Produces a k-t sampling pattern for T2 Shuffling acquisition

dims = [256, 256];
accel = [1.34, 1.34]; % used to control number of echo trains (scan time)
ETL = 82;
e2s = 2;
shuffle = true;
cut_corners = true;
num_masks = 8;
VD = 3;
mask_cal_size = 12;

% --- do not change below this point

options.dims = dims;
options.accel = accel;
options.ETL = ETL;
options.e2s = e2s;
options.shuffle = shuffle;
options.cut_corners = cut_corners;
options.num_masks = num_masks;
options.VD = VD;
options.mask_cal_size = mask_cal_size;

[masks, y_echoes, z_echoes, sp_mask] = gen_t2shuffling_mask(options);