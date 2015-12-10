function res = admm_callback(alpha, history, ii)

[ny, nz, K] = size(alpha);
figure(1);
subplot(211); imshowc(reshape(alpha, ny, nz*K));
subplot(212); plot(1:ii, history.objval);

res = 0;
end
