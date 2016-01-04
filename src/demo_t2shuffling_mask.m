%%%%%%
% This code produces a k-t sampling pattern for T2 Shuffling acquisition.
% The full description can be found in the MRM paper,
% "T2 Shuffling: Sharp, Multi-Contrast, Volumetric Fast Spin-Echo Imaging"
%
% The code is provided to demonstrate the method. It is not optimized
% for reconstruction time
%
% Jonathan Tamir <jtamir@eecs.berkeley.edu>
% Jan 03, 2016
%
%%
addpath src/utils

%% parameters
dims = [260, 240];
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

figure(1);
imshow(reshape(masks(:,:,1:e2s+3), dims(1), []));
ftitle(sprintf('Sampling patterns for first %d TEs', e2s+3));

masks_avg = sum(masks(:,:,e2s+1:end), 3);
figure(2);
imshow(reshape(masks_avg, dims(1), []));
ftitle('Sampling pattern summed over time');
