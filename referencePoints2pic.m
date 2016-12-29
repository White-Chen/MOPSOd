% Author				: ChenZhe 
% Create Time			: Friday, March 25, 2016
% Completion Time		: Saturday, March 26, 2016

% Function referencePoints2pic   
% 						: show the referencePoints in a normalizaed Space 

% Input variables:
% 	referencePoints     : Set Of referencePoints
% Output variables:
% 	pic 			    : placeholder variable
function pic = referencePoints2pic(referencePoints)

    dimensionSize = size(referencePoints,2);
    
    % 2-D
    if (dimensionSize == 2)
        plot(referencePoints(:,1),referencePoints(:,2),'ko',...
                                'MarkerFace','k','MarkerSize',2);
    	xlabel('1^{st} Obejctive');
    	ylabel('2^{nd} Obejctive');
    % 3-D
    elseif(dimensionSize == 3)
        plot3(referencePoints(:,1),referencePoints(:,2),...
    							referencePoints(:,3),'ko',...
                                'MarkerFace','k','MarkerSize',2);
    	xlabel('1^{st} Obejctive');
    	ylabel('2^{nd} Obejctive');
    	zlabel('3^{rd} Obejctive');
    	view(-243,29);
		axis square;
    % 2-D parallel ordination
    elseif(dimensionSize > 3)
        for i = 1:size(referencePoints,1)
    		plot(referencePoints(i,:));
    		hold on;
    	end
    	xlabel('Obejctive Number');
    	ylabel('Objective Value');
    	set(gca, 'XTick', [1:1:dimensionSize]);
		% set(gca,'XTickLabel',{'f1','f2','f3','f4','f5'});
    	hold off;
	% Error~
    else
        disp('Something wrong!!!!');
        return;
    end

    grid on;
    set(gcf,'color','w');
    title(['ReferencePoints in ',num2str(dimensionSize),'-D Space']);
	
	clear dimensionSize referencePoints i;
end