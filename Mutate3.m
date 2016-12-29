function newparticle = Mutate3(index,particle,rep_h,VarMin,VarMax)
	neighbourIndex = particle(index).Niche;
	nsize = length(neighbourIndex);
	si = ones(1,2)*index;
	si(1)=neighbourIndex(ceil(rand*nsize));
    while si(1)==index
        si(1)=neighbourIndex(ceil(rand*nsize));
    end
    si(2)=neighbourIndex(ceil(rand*nsize));
    while si(2)==index || si(2)==si(1)
        si(2)=neighbourIndex(ceil(rand*nsize));
    end
    parDim = size(VarMax,2);
    selectpoints = [rep_h.Position;reshape([particle(si).Position],parDim,2)'];
    oldpoint = [particle(index).Position];
    jrandom = ceil(rand*parDim);
    randomarray = rand(1,parDim);
    deselect = randomarray<0.5;
    deselect(jrandom)=true;
    newpoint = selectpoints(1,:)+0.5*(selectpoints(2,:)-selectpoints(3,:));
    newpoint(~deselect)=oldpoint(~deselect);
    newpoint=max(newpoint, VarMax);
    newpoint=min(newpoint, VarMin);
    particle(index).Position = newpoint;
    particle(index).Velocity = 0;
    particle(index).T = 0;
    newparticle = particle(index);
end