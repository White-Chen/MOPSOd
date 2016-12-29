function particles = DeleteFromRep2(particles, weights, idealpoint, varargin)
	global dmethod numOfObj nPop niche;

	nWeights = size(weights,1);
	nParticles = numel(particles);
	if isempty(varargin)
		r = nWeights;
	else
		r = varargin{1};
	end
	xSelectedIndex = false(1,nParticles);
	pSelectedIndex = false(1,nWeights);
	p_xMappingIndex = zeros(1,nParticles);
	selectedMatrix = false(nWeights,nParticles);
	costMatrix = reshape([particles.Cost],numOfObj,nParticles)';

    tempObjMatrix = arrayfun(@(x)...
    						 (subobjective(repmat(x{:},nParticles,1),costMatrix,idealpoint.Cost,dmethod)),...
							 num2cell(weights,2),...
							 'UniformOutput',...
							 false);
    [~, pMatrix] = sort(reshape(cell2mat(tempObjMatrix),nParticles,nWeights)',...
                                    2);
    clear tempObjMatrix;
    
 	tempsum = sum((weights.*weights),2);
	tempObjMatrix = arrayfun(@(x)...
    						 (...
    						 	arrayfun(@(y)(norm(y{:})),...
										 num2cell((repmat(x{:},nWeights,1) - repmat(sum((weights.*repmat(x{:},nWeights,1)),2)./tempsum,1,numOfObj).*weights),2),...
										 'UniformOutput',...
							 			 true)...
					 		 ),...
							 num2cell(costMatrix,2),...
							 'UniformOutput',...
							 false);
	[~, xMatrix] = sort(reshape(cell2mat(tempObjMatrix),nWeights,nParticles)',...
                                    2);
	clear tempObjMatrix tempsum;

	if ~isempty(varargin)
		[pSelectedIndex,xSelectedIndex,selectedMatrix,p_xMappingIndex]...
				= subfunction(pSelectedIndex,xSelectedIndex,selectedMatrix,p_xMappingIndex,xMatrix(:,1:r),pMatrix);
	end
	[~,~,~,p_xMappingIndex]...
				= subfunction(pSelectedIndex,xSelectedIndex,selectedMatrix,p_xMappingIndex,xMatrix,pMatrix);

	for i = 1:nParticles
		if p_xMappingIndex(i) == 0
			continue;
		end
		particles(i).weight = weights(p_xMappingIndex(i),:);
	end
	particles(p_xMappingIndex == 0) = [];
	particles = init_niche(particles,niche,nPop);   
	clear costMatrix nWeights nParticles xMatrix pMatrix xSelectedIndex pSelectedIndex p_xMappingIndex i;
end

%% subfunction: function description
function  [pSelectedIndex,xSelectedIndex,selectedMatrix,p_xMappingIndex,xMatrix,pMatrix]...
				= subfunction(pSelectedIndex,xSelectedIndex,selectedMatrix,p_xMappingIndex,xMatrix,pMatrix)
	r = size(xMatrix,2);
	sum_r = size(pMatrix,1);
	if r == sum_r
		uniqueWeights = [1:sum_r];
		controlParams = 0;
    else
    	flagMatrix = true(1,size(xMatrix,1));
    	tempMatrix = [];
    	tempNum_A = 0;
        tempNun_B = 0;
    	for i = 1:r
    		tempMatrix = [tempMatrix xMatrix(flagMatrix,i)'];
    		[uniqueWeights,uniqueWeightsI_row,~] = unique(tempMatrix,'stable');
    		ttempMatrix = find(flagMatrix);
			flagMatrix(ttempMatrix(uniqueWeightsI_row(tempNum_A+1:end)-tempNun_B)) = false;    		
    		tempNum_A = length(uniqueWeightsI_row);
            tempNun_B = length(tempMatrix);
    		clear ttempMatrix;
		end
	    controlParams = sum_r - tempNum_A;
        
        clear flagMatrix uniqueWeightsI_row tempNum_A tempMatrix tempNun_B;
	end

	while(length(pSelectedIndex(~pSelectedIndex))) > controlParams
		tempFalseIndex = intersect(find(~pSelectedIndex),uniqueWeights);
		pIndex = tempFalseIndex(randperm(length(tempFalseIndex),1));
		xIndexs = pMatrix(pIndex,~selectedMatrix(pIndex,:));
		xIndex = xIndexs(1);
		selectedMatrix(pIndex,pMatrix(pIndex,:)==xIndex) = true;

		if (~xSelectedIndex(xIndex))
			p_xMappingIndex(xIndex) = pIndex;
			pSelectedIndex(pIndex) = true;
			xSelectedIndex(xIndex) = true;
		elseif find(xMatrix(xIndex,:) == p_xMappingIndex(xIndex), 1, 'first') >...
				find(xMatrix(xIndex,:) == pIndex, 1, 'first')
			pSelectedIndex(p_xMappingIndex(xIndex)) = false;
			p_xMappingIndex(xIndex) = pIndex;
			pSelectedIndex(pIndex) = true;
        end
		clear pIndex xIndexs xIndex tempFalseIndex;
    end
    clear r sum_r uniqueWeights controlParams;
end
