function z = MyCost5(x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

    z = [0,0];
    n = numel(x);
    g = 1 + 9*(sum(x(2:n))/(n-1))^0.25;

    z(1) = 1 -exp(-4*x(1))*sin(6*pi*x(1))^6;
    z(2) = g*(1-(z(1)/g)^2);
end

