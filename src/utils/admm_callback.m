function res = admm_callback(alpha, history, ii)

[ny, nz, K] = size(alpha);
figure(1);
subplot(211); imshowc(reshape(alpha, ny, nz*K)); ftitle('Coefficient Images');
subplot(212); plot(1:ii, history.objval); ftitle('Objective Value');
xlabel('Iteration Number'); faxis;

res = 0;
end
