function [particle,weights]=init_weights(particle,objDim)
	popsize = numel(particle);
	weights = [];
    if objDim==2
    	for i=1:popsize
            weight=zeros(1,2);
            weight(1)= (i-1)/(popsize-1);
            weight(2)= 1 - weight(1);
            weights = [weights;weight];
            particle(i).weight=weight;
        end
    elseif objDim >= 3
    	weights = referencePointsGenerator(objDim,'single',23);
        for i=1:popsize
            particle(i).weight=weights(i,:);
        end
    end

    clear i;
end