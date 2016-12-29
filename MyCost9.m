%% zdt4
function z = MyCost9(x)

    z = [0,0];
    g = 1 + 10*(10-1);
    for i = 2:10
    	g = g+x(i)^2-10*cos(4*pi*x(i));
	end
    z(1) = x(1);
    z(2) = g*(1-sqrt(x(1)/g));
end