function [ sig ] = FSE_signal(angles_rad, TE, T1, T2)
%FSE_signal simulate a FSE CPMG sequence. Based on Extended Phase Graph
%code written by Brian Hargreaves: http://web.stanford.edu/~bah/software/epg/
%
% Inputs:
%  angles_rad (rad) -- flip angle train in radians
%  TE (s) -- echo spacing
%  T1 (s) -- T1 value
%  T2 (s) -- T2 value
%
% Outputs:
%  sig -- complex-valued transverse magnetization at each echo


P = [0; 0; 1]; % initial magnetization in Mz.
P = epg_rf(P, pi/2, pi/2); % 90 degree flip angle out of phase

T = length(angles_rad);
sig = zeros(T, 1);

for ii=1:T
    P = epg_grelax(P, T1, T2, TE/2);
    P = epg_rf(P, angles_rad(ii), 0);
    P = epg_grelax(P, T1, T2, TE/2);
    
    sig(ii) = P(1,1); % signal is F0 state
    
end

end