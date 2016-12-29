function xnew=Mutate2(x,pm,VarMin,VarMax)

    nVar=numel(x);
    j=randi([1 nVar]);
    dx=pm*(VarMax(j)-VarMin(j));
    lb=x(j)-dx;
    if lb<VarMin(j)
        lb=VarMin(j);
    end
    ub=x(j)+dx;
    if ub>VarMax(j)
        ub=VarMax(j);
    end
    xnew=x;
    xnew(j)=unifrnd(lb,ub);

end