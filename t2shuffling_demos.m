fprintf('T2 Shuffling demonstration code and support files.\n');
fprintf('The following code accompanies the MRM paper,\n\n');
fprintf('\tJ.I. Tamir, M. Uecker, W. Chen, P. Lai, M.T. Alley, S.S. Vasanawala, M. Lustig,\n');
fprintf('\t"T2 Shuffling: Sharp, Multi-Contrast, Volumetric Fast Spin-Echo Imaging"\n');
fprintf('\tMagn. Reson. Med,, Early View, 2016\n\n');


D = dir('src/demo_*.m');
t2sdemos = {D.name}';

fprintf('Available demos:\n');
for ii=1:length(t2sdemos)
    fprintf('%s:\n', t2sdemos{ii});
    eval(['help ', t2sdemos{ii}]);
end
fprintf('Run "help <demo>" for more information about each demo\n');
