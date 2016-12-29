function temprep = DeleteFromRep(rep,weights,idealpoint,numOfObj,nRep)
    global dmethod;
	temprep = [];
	weightSize = size(weights,1);

	for k = 1:weightSize
        tempWeightMatrix = repmat(weights(k,:),numel(rep),1);
        temp_rep_cost = reshape([rep.Cost],numOfObj,numel(rep))';
        Obj = subobjective(tempWeightMatrix, temp_rep_cost, idealpoint.Cost, dmethod);
        [vals ObjIndex] = min(Obj);
        temprep = [temprep;rep(ObjIndex)];
        rep(ObjIndex) = [];
	end
end