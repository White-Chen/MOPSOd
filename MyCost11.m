% ZDT6'

function z = MyCost11(x)
    z = [0,0];
    g = 1 + 10*(10-1);
    for i = 2:10
    	g = g+x(i)^2-10*cos(4*pi*x(i));
	end
    z(1) = 1-exp(-4*x(1))*(sin(6*pi*x(1)))^6;
    z(2) = g*(1-(x(1)/g)^2);
end