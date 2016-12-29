function [rep,particle,sigmaArray] = computeSigma(rep,particle,sigmaArray)
    global CostFunction nVar VarMin VarMax numOfObj VarSize nPop idealpoint;
    indexArray = rand(1,length(rep))<0.3;
    selectedRep = rep(indexArray);   
    for tempr = 1:length(rep)
        rep(tempr).Cost = CostFunction(rep(tempr).Position);
    end
    newSelectedRep = rep(indexArray);
    sigma = sum(sum([newSelectedRep.Cost]-[selectedRep.Cost]))/length(selectedRep);
    clear tempr indexArray selectedRep newSelectedRep;

    if(length(sigmaArray) >= 1)
        sigma = min( (numOfObj-1) * ( (sigma-min(sigmaArray)) / (max(sigmaArray)-min(sigmaArray)) ), 1.0);
    end
    sigmaArray = [sigmaArray;sigma];
    tnum = ceil(sigma*nPop);
    tempPop = particle;
    pop1 = [];
    for ttt = 1:tnum
        index = ceil(rand*length(tempPop));
        pop1 = [pop1;tempPop(index)];
        tempPosition=unifrnd(0,1,VarSize);
        pop1(end).Position = tempPosition .* (VarMax-VarMin) + VarMin;
        pop1(end).Cost=CostFunction(pop1(end).Position);
        pop1(end).Best.Position=pop1(end).Position;
        pop1(end).Best.Cost=pop1(end).Cost;
        idealpoint = update_idealpoint(pop1(end),idealpoint);
        pop1(end).T = 0;
        tempPop(index) = [];
    end
    pop2 = tempPop;
    for ttt = 1:length(pop2)
        pop2(ttt).Position = pop2(ttt).Position + normrnd(0,sigma,[1,nVar]);
        pop2(ttt).Cost=CostFunction(pop2(ttt).Position);
        pop2(ttt).Best.Position=pop2(ttt).Position;
        pop2(ttt).Best.Cost=pop2(ttt).Cost;
        idealpoint = update_idealpoint(pop2(ttt),idealpoint);
        pop2(ttt).T = 0;
    end
    particle = [pop1;pop2];
    clear tnum ttt tempPop pop1 pop2 tempPosition index;
end