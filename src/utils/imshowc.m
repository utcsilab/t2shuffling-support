function imshowc( img, range )
%imshowc convenience function for plotting
% abs(img)

if nargin < 2
    range = [];
end

imshow(abs(img), range);
impixelinfo
end

