%% zdt2
function z = MyCost8(x)

    z = [0,0];
    n = numel(x);
    g = 1 + 9*sum(x(2:n))/(n-1);

    z(1) = x(1);
    z(2) = g*(1-(x(1)/g)^2);
end