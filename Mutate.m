function particle=Mutate(particle,rep_h,VarMin,VarMax)
    nVar=numel(particle.Position);
    particle.Position = normrnd((rep_h.Position-particle.Best.Position)/2,abs(rep_h.Position-particle.Best.Position));
    particle.Velocity = zeros(size(particle.Velocity));
    particle.T = 0;
end