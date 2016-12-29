function nd_pop=GetNonDominatedParticles(pop)
    ND=~[pop.Dominated];
    nd_pop=pop(ND);
end