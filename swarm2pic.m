function swarm2pic(rep,varargin)
    global numOfObj dynamic itrCounter colors window;
    if itrCounter == 1 && dynamic  == 1
        set(0,'units','centimeters');
        position    =[0 0 51 19.5];
        h           =figure;
        set(h,'PaperType','A4'); 
        set(h,'PaperUnits','centimeters'); 
        set(h,'paperpositionmode','auto');
        set(h,'PaperPosition',position);
        set(h,'units','centimeters');
        set(h,'position',position);
        hold off;
    end 
    if numel(varargin) == 0;
        if dynamic == 0
            subfunction(rep,numOfObj,'rx',6);
        else
            subplot(1,2,1);
            subfunction(rep,numOfObj,'rx',6);
            hold off;
            if mod(itrCounter,window) == 0
                subplot(1,2,2);
                subfunction(rep,numOfObj,colors{mod(floor(itrCounter/window),18)+1},4);
                hold on;
                % [rep,particle,sigmaArray] = computeSigam(rep,particle,sigmaArray);
            end
        end
        title(['Ring Iteration: ',num2str(itrCounter)]);
        drawnow;
    else
        hold off;
        figure;
        if numOfObj == 2
            costs=GetCosts(varargin{1});
            rep_costs=GetCosts(rep);
            plot(rep_costs(1,:),rep_costs(2,:),'rx');
            hold on;
            plot(rep_costs(1,:),rep_costs(2,:),'rx');
            legend('Main Population','Repository');
            hold off;
        end
        if numOfObj == 3
            costs=GetCosts(varargin{1});
            rep_costs=GetCosts(rep);
            plot3(rep_costs(1,:),rep_costs(2,:),...
                                rep_costs(3,:),'ko'...
                                );
            hold on;
            plot3(costs(1,:),costs(2,:),...
                                costs(3,:),'ko'...
                                );
            legend('Main Population','Repository');
            view(-243,29);
            axis square;
            grid on;
            hold off;
        end
    end
end

function subfunction(rep,numOfObj,colorStr,markersize) 
   if numOfObj == 2
        rep_costs=GetCosts(rep);
        plot(rep_costs(1,:),rep_costs(2,:),colorStr,'markersize',markersize);
        hold off;
    end
    if numOfObj == 3
        rep_costs=GetCosts(rep);
        plot3(rep_costs(1,:),rep_costs(2,:),...
                            rep_costs(3,:),...
                            colorStr,'markersize',markersize);
        view(-243,29);
        axis square;
        grid on;
        hold off;
    end 
end