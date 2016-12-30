function particle = updateNeighbour(particle,index,idealpoint)
	global dmethod;
	neighbourIndex = particle(index).Niche;
	neighbourWeight = reshape([particle(neighbourIndex).weight],size(particle(1).weight,2),length(neighbourIndex))';
	newObj = subobjective(neighbourWeight, [particle(index).Cost], [idealpoint.Cost], dmethod);
	% neighbours = [particle(neighbourIndex).Best]';
	oops = reshape([particle(neighbourIndex).Cost], size(particle(1).Cost,2), length(neighbourIndex))';
	oldObj = subobjective(neighbourWeight, oops, [idealpoint.Cost], dmethod);

	C = newObj < oldObj;
	% [particle(neighbourIndex(C)).Best] = deal(struct('Position',particle(index).Position,'Cost',particle(index).Cost));
	[particle(neighbourIndex(C)).Position] = deal(particle(index).Position);
    [particle(neighbourIndex(C)).Cost] = deal(particle(index).Cost);
	clear neighbourIndex newObj oops oldObj C neighbours;
end