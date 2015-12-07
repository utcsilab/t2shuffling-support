myT2vals = load('data/T2vals', 'T2vals'); % T2 values in seconds
myT1vals = [1000;]*1e-3; % T1 values in seconds
angles = dlmread('data/flipangles.txt');

T = 80; % echo train length
e2s = 2; % number of intial echoes 2 skip
TE = 5.688e-3; % echo time
verbose = 1;

N = 256; % maximum number of unique T2 values for training

[U, X, T2vals, T1vals, TE, e2s] = gen_FSEbasis(N, angles, T, e2s, TE, myT2vals, myT2vals, verbose);