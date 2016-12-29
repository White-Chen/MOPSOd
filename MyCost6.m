function z = MyCost6(x)

    z = [0,0];
    n = numel(x);
    g = 1 + 9*sum(x(2:n))/(n-1);

    z(1) = x(1);
    z(2) = g*(1-sqrt(x(1)/g) - x(1)/g*sin(10*pi*x(1)));
end