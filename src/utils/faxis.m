function faxis(ax, fontsize )

if nargin < 1
    ax = gca;
end

if nargin < 2
    fontsize = 16;
end

set(ax, 'fontsize', fontsize);

xlhand = get(ax,'xlabel');
set(xlhand,'fontsize', fontsize);

ylhand = get(ax,'ylabel');
set(ylhand,'fontsize', fontsize);

end

