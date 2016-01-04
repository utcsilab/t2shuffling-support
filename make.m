addpath src

fprintf('Mexing Variable Density Poisson Disc Mas...\n');
cd src/utils
mex vdPoisMex.c
cd ../..
fprintf('Done.\n');