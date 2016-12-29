function leader = SelectLeader2(particle,index)
    index2 = ceil(rand*length(particle(index).Niche));
    while (index2 == index)
        index2 = ceil(rand*length(particle(index).Niche));
    end
    leader = particle(index2).Best;    
end