function pop=DetermineDomination(pop)
    npop=numel(pop);
    for i=1:npop
        pop(i).Dominated=false;
        for j=1:i-1
            if ~pop(j).Dominated
                if Dominates(pop(i),pop(j)) 
                    pop(j).Dominated=true;
                elseif Dominates(pop(j),pop(i)) 
                    pop(i).Dominated=true;  
                    break;
                end
            end
        end
    end

end