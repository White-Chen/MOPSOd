%% DTZL2

function z = MyCost4(x)
    
    z = [0, 0, 0];

    g = sum((x(3:end)-0.5).^2);

    z(1) = (1+g) * cos(x(1)*pi/2) * cos(x(2)*pi/2);
    z(2) = (1+g) * cos(x(1)*pi/2) * sin(x(2)*pi/2);
    z(3) = (1+g) * sin(x(1)*pi/2);

end