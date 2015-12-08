%% multiecho_sim.m
%
% Takes {proton density, T2, mask} images and a flipangle train, and
% simulates a time series of virtual echo time images
%
% final output is imgs [ny, nz, T]

addpath src/utils

use_flipmod = true; % true -- variable flip angles, false -- exp decay
T1 = 1000e-3;
TE = 5.688e-3; % echo time
T = 80; % echo train length
e2s = 2; % initial skipped echoes
t2map_data = 'data/foot_t2map.mat'; % contains proton, T2est, mask, T2vals
imratio = 256/256; % downsample the image for computation purposes

% --- do not change below this point

if use_flipmod
    angles = dlmread('data/flipangles.txt');
    angles_rad = angles*pi/180;
    T = min(T, length(angles));
end

%% load image data
load(t2map_data);

T2im = imresize(mask.*T2est, imratio); T2im(T2im<0) = 0;
proton = imresize(mask.*proton, imratio);
[ny, nz] = size(T2im);

%% simulate
if use_flipmod
    % simulate all of T2vals or all of T2im, whatever is smaller
    T2vals_im = unique(T2im(:));
    if length(T2vals_im) < length(T2vals)
        T2vals = T2vals_im;
    end
    L = length(T2vals);
    X = zeros(length(angles_rad), L);
    for ii=1:L
        if mod(ii, 500) == 0
            disp([num2str(ii), '/',num2str(L)]);
        end
        T2 = T2vals(ii);
        X(:, ii) = real(FSE_signal(angles_rad, TE, T1, T2));
    end

    keep = (e2s+1:T+e2s);
    im = zeros(ny,nz,T);
    for yy=1:ny
        disp(yy)
        for zz=1:nz
            if T2im(yy,zz) == 0
                im(yy,zz,:) = 0;
            else
                im(yy,zz,:) = X(keep, T2vals==T2im(yy,zz));
            end
        end
    end
    imgs = im.*repmat(proton, [1 1 T]);
    
else
    echo_times = (e2s+1)*TE:TE:(e2s+T)*TE;
    imgs = zeros(ny,nz,T);
    for ii=1:T
        imgs(:,:,ii) = proton.*exp(-echo_times(ii)./T2im);
    end
end
