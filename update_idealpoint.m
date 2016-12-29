function idealpoint = update_idealpoint(particle,idealpoint)
	particle_cost = [particle.Cost];
	idealpoint_cost = [idealpoint.Cost];
	index = find(particle_cost < idealpoint_cost);
	idealpoint.Cost(index) = particle.Cost(index);
end