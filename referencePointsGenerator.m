% Author				: ChenZhe 
% Create Time			: Friday, March 25, 2016
% Completion Time		: Saturday, March 26, 2016

% Reference:
% [1] NORMAL-BOUNDARY INTERSECTION: A NEW METHOD FOR GENERATING THE
%     PARETO SURFACE IN NONLINEAR MULTICRITERIA OPTIMIZATION PROBLEMS
% [2] An Evolutionary Many-Objective Optimization Algorithm Using
%     Reference-Point-Based Nondominated Sorting Approach, Part I:
%     Solving Problems With Box Constraints

% Function referencePointsGenerator 
% 						: generate a set of referencePoints

% Input variables:
%	numberOfObjective   : Objective Space Demension Size
%   numberOfDivision    : 
% 	varargin            : Specific for two-layers intersection method
%   varargin{1}			: 'single' - represent default intersection
% 										method(ref[1]).
% 						  'two'    - represent two-layers intersection
%										method(ref[2]).
% 	varargin{2}			: If varargin{1} is 'single', this represents
% 						  division Space Demension Size. default is 9.
% 						  If varargin{1} is 'two', this represents
% 						  division number for first-layers, if null,
% 						  default is 3.
% 
% Output variables:
% 	referencePoints     : Set Of referencePoints

% Note: When the numberOfObjective >= numberOfDivision, the size of 
% 		referencePoints is so large in ref.[1]. So in ref.[2], professor
% 		Deb introduce a method called two-layers intesection method, 
% 		which can decrease the size of referencePoints greatly.

function referencePoints =...
    referencePointsGenerator(numberOfObjective,	varargin)
    
    % initialize params
    vararginSize = numel(varargin);
    divisionMethod = 'single';
	numberOfDivision = 9;
	firstLayerDivision = 3;
	secondLayerDivision = 2;
    referencePoints = [];
    
    % handle varargin
	if (vararginSize == 1)
		divisionMethod = varargin{1};
	end
	if (vararginSize > 1)
		if (strcmp(varargin{1},'two'))
			divisionMethod = 'two';
			firstLayerDivision = varargin{2};
			secondLayerDivision = varargin{2} - 1;	
		else
			numberOfDivision = varargin{2};
		end
	end
	clear vararginSize;

    % change the dispaly format from 'short' to 'rat'
    format rat;
    
    % round number
    numberOfObjective = round(numberOfObjective);
    numberOfDivision  = round(numberOfDivision);

    % when divisionMethod is 'single'
    % use the normal-boundary intersection
    if (strcmp(divisionMethod,'single'))

    	% generate name matrix for automatic code

		% Sample data
    	% Set of possible letters
		x = [0:numberOfDivision];                 
		% Create all possible permutations (with repetition) of letters stored in x
		% Preallocate a cell array
		C = cell(numberOfObjective, 1);         
		% Create K grids of values    
		[C{:}] = ndgrid(x);       
		% Convert grids to column vectors  
		permutationMatrix = cellfun(@(x){x(:)}, C); 
		permutationMatrix = [permutationMatrix{:}];              

	    % combine the numberOfDivision permutionMatrixs into one Matrixs
	    referencePoints = permutationMatrix(find(sum(permutationMatrix,2)...
	                        ==numberOfDivision),:);
	    clear permutationMatrix x C;

    	% Normalization
	    referencePoints = referencePoints/numberOfDivision;
    end

    % two-layers intersection
    if (strcmp(divisionMethod,'two'))
    	firstLayerReferencePoints = referencePointsGenerator(numberOfObjective,...
    							'single',firstLayerDivision);
    	secondLayerReferencePoints = referencePointsGenerator(numberOfObjective,...
    							'single',secondLayerDivision);
		referenceSurfaceCenter = mean(firstLayerReferencePoints,1);
		secondLayerReferencePoints = secondLayerReferencePoints + ...
			repmat(referenceSurfaceCenter,size(secondLayerReferencePoints,1),1);
		secondLayerReferencePoints = secondLayerReferencePoints/2;

		referencePoints = [firstLayerReferencePoints;secondLayerReferencePoints];
		clear firstLayerReferencePoints secondLayerReferencePoints referenceSurfaceCenter;
	end
    clear divisionMethod numberOfDivision firstLayerDivision secondLayerDivision i;
end