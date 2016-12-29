function obj = subobjective(weight, ind, idealpoint, method)
    if (nargin==2)
        obj = ws(weight, ind);
    elseif (nargin==3)
        obj = te(weight, ind, idealpoint);
    else
        if strcmp(method, 'ws')
            obj=ws(weight, ind);
        elseif strcmp(method, 'te')
            obj=te(weight, ind, idealpoint);
        elseif strcmp(method,'pbi')
        	obj=pbi(weight,ind, idealpoint,5);
        else
            obj= te(weight, ind, idealpoint);
        end
    end
end

function obj = ws(weight, ind)
    if size(ind, 2) == 1 
       obj = (weight'*ind)';
    else
       obj = sum(weight.*ind);
    end
end

function obj = te(weight, ind, idealpoint)
    s = size(weight, 1);
    indsize = size(ind,1);
    
    if indsize==s 
        idealpoint = repmat(idealpoint,indsize,1);
        part2 = abs(ind-idealpoint);
        obj = max(weight.*part2,[],2);
    elseif indsize ==1
        part2 = abs(ind-idealpoint);
        obj = max(weight.*part2(ones(s,1),:),[],2);   
    else
        error('individual size must be same as weight size, or equals 1');
    end
end


function obj = pbi(weight, ind, idealpoint, penalty)
    weight = weight';
    ind = ind';
    idealpoint = idealpoint';

    weightColumn = size(weight, 2);
    weightRow = size(weight,1);
    indsize = size(ind,2);
    if indsize == 1
        ind = ind(:,ones(1,weightColumn));
        temp = idealpoint(:,ones(1,weightColumn))-ind;
    else 
        temp = idealpoint(:,ones(1,weightColumn))-ind;
    end

    weightNorm = ones(1,weightColumn);
    tempNorm = ones(1,weightColumn); 
    for k = 1:weightColumn
        weightNorm (:,k) = norm(weight(:,k));
        tempNorm(:,k) = norm(temp(:,k));
    end
    unitVector =weight./weightNorm(ones(1,weightRow),:);

    d1 = dot(weight,temp)./weightNorm;
    d2 = ind-(idealpoint(:,ones(1,weightColumn))-d1(ones(1,weightRow),:).*unitVector);
    d2Norm = ones(1,weightColumn);
    for k = 1:weightColumn
        d2Norm(:,k) = norm(d2(:,k));
    end
    obj = (abs(d1)+penalty.*abs(d2Norm));
end