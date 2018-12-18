function [left,right,center] = binContribs(x)
%binContribs returns what percentage of the gradient vector's
%weight goes to each bin on the histogram
%   histogram is 9 bins: 10, 30, 50, 70 ...
%if gradient is 85, it must give 3/4 of it's weight to bin 90 and 1/4 to
%bin 70. results are given as a value between 0 and 1
%input is value between -10 and 10
if(x >= 0)
    left = 0;
    right = 0.5 * (x/10);
    center = 1 - right;
else
    left = 0.5 * (-x/10);
    right = 0;
    center = 1 - left;
end

