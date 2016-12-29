function z = MyCost10(x)
    
    z = [0 0];
    n = numel(x);
    for i = 1:n-1
        z(1) = z(1) - 10*exp(-0.2*sqrt((x(i))^2 + (x(i + 1))^2));
    end
    for i = 1:n
       z(2) = z(2) + (abs(x(i))^0.8 + 5*(sin(x(i)))^3); 
    end

end

