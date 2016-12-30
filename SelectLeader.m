function rep_h=SelectLeader(rep,particle,weights,numOfObj,niche)
	

	% function 1
	% select the undominated pop with the same weight forever
	% weight = particle.weight;
	% repsize = numel(rep);
	% rep_weight = reshape([rep.weight],numOfObj,repsize)';
	% [logics,index] = ismember(weight,rep_weight,'rows');
	% if logics == 1
	% 	rep_h = rep(index);
	% else
	%     j = ceil(rand*repsize);
	%     rep_h = rep(j);
	% end

% 	funciton 2
% 	random select from all the undominated pop;
% 	repsize = numel(rep);
% 	j = ceil(rand*repsize);
% 	rep_h = rep(j);

	% function 3
	% select from neighbor in the range of niche
	repsize = numel(rep);
	rep_weight = reshape([rep.weight],numOfObj,repsize)';
    logics =boolean(0);
    t = 0;
	while t < 3 && ~logics
        t = t +1;
        j = ceil(rand*niche);
        select_weight = weights(particle.Niche(j),:);
        [logics,index] = ismember(select_weight,rep_weight,'rows');
    end
	if  logics == 0
		j = ceil(rand*repsize);
		rep_h = rep(j);
    else
        rep_h = rep(index);
    end
end