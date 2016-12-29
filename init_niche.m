function pop = init_niche(pop,niche,nPop)
	if (niche <= 0 || niche >= nPop)
		for k = 1:nPop
			pop(k).Niche = [1:1:nPop];
		end
	else if niche 
		distanceMatrix = zeros(nPop,nPop);
		for k = 1:nPop
			for j = k + 1 : nPop
				A_weight = pop(k).weight;
				B_weight = pop(j).weight;
				distanceMatrix(k,j) = (A_weight - B_weight)*(A_weight - B_weight)';
				distanceMatrix(j,k) = distanceMatrix(k,j);
			end
			[s, sindex] = sort(distanceMatrix(k,:));
			pop(k).Niche = sindex(1:niche);
		end
	end

	clear k j;
end