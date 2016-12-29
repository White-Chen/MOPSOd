function costs=GetCosts(pop)
    nobj=numel(pop(1).Cost);
    costs=reshape([pop.Cost],nobj,[]);
end