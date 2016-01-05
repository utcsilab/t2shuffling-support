addpath src

fprintf('Mexing Variable Density Poisson Disc Mas...\n');
cd src/utils
mex vdPoisMex.c
cd ../..
fprintf('Done.\n\n');


fprintf('Unpacking knee data set...\n');
cd data/knee
unzip knee_data.zip
cd ../..
fprintf('Done.\n\n');