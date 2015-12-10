function [ xhat ] = SoftThresh(y, lambda)
% SoftThresh Soft Threshold y at value lambda

xhat = y.*(abs(y) - lambda)./abs(y);
xhat(abs(y) <= lambda) = 0;

end
