clc;
clear;
close all;
%% Problem Definition
global dmethod itrCounter step window CostFunction nVar nPop niche VarMin VarMax numOfObj VarSize VelMax TestProblem dynamic idealpoint;
TestProblem=33; 
dynamic = 1;
initialProblem();
dmethod = 'te';
step = 10;
window = 1000;
itrCounter = 0;
VarSize=[1 nVar]; 
VelMax=(VarMax-VarMin); 
nPop=100;  
nRep=100;  
MaxIt=10000; 
phi1=2.05; 
phi2=2.05;
phi=phi1+phi2;  
chi=2/(phi-2+sqrt(phi^2-4*phi));
w=chi;              
wdamp=1;            
c1=chi*phi1;        
c2=chi*phi2;
mu=0.1;
Ta = 4;
niche = 20;
particle=CreateEmptyParticle(nPop);
idealpoint = CreateEmptyParticle(1);
idealpoint.Cost = Inf*ones(1,numOfObj);
sigmaArray = [];
for i=1:nPop
    particle(i).Velocity=zeros(1,nVar);    
    tempPosition=unifrnd(0,1,VarSize);
    particle(i).Position = tempPosition .* (VarMax-VarMin) + VarMin;
    particle(i).Cost=CostFunction(particle(i).Position);   
    particle(i).Best.Position=particle(i).Position;
    particle(i).Best.Cost=particle(i).Cost;
    idealpoint = update_idealpoint(particle(i),idealpoint);
    particle(i).T = 0;
end
clear i;
[particle,weights] = init_weights(particle,numOfObj);
particle =  init_niche(particle,niche,nPop);
particle=DetermineDomination(particle); 
rep=GetNonDominatedParticles(particle); 
if dynamic  == 1
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
for itrCounter=980:MaxIt
    % DeleteFromRep2(particle,weights,idealpoint,25);
    for i=1:nPop
        rep_h=SelectLeader(rep,particle(i),weights,numOfObj,niche);
%         rep_h=SelectLeader2(rep,i);
        if (particle(i).T <= Ta)
	        particle(i).Velocity=w*particle(i).Velocity ...
	                             +c1*rand*(particle(i).Best.Position - particle(i).Position)...
	                             +c2*rand*(rep_h.Position -  particle(i).Position);
	        particle(i).Velocity=min(max(particle(i).Velocity,-VelMax),+VelMax);
	        particle(i).Position=particle(i).Position + particle(i).Velocity;
	        
        else
            particle(i) = Mutate(particle(i),rep_h,VarMin,VarMax);
    	end
       
        flag=(particle(i).Position<VarMin | particle(i).Position>VarMax);
        particle(i).Velocity(flag)=-particle(i).Velocity(flag);
        particle(i).Position=min(max(particle(i).Position,VarMin),VarMax);
        particle(i).Cost=CostFunction(particle(i).Position);
        idealpoint = update_idealpoint(particle(i),idealpoint);
        if (subobjective([particle(i).weight], [particle(i).Cost], [idealpoint.Cost],dmethod) < ...
            subobjective([particle(i).weight], [particle(i).Best.Cost], [idealpoint.Cost], dmethod))
            particle(i).Best.Cost = particle(i).Cost;
            particle(i).Best.Position = particle(i).Position;
            particle(i).T = 0;
        else
        	particle(i).T = particle(i).T + 1;
%             particle = updateNeighbour(particle,i,idealpoint);
        end
%         particle=DetermineDomination(particle);
%         nd_particle=GetNonDominatedParticles(particle);
        rep=[rep
             particle(i)];
        rep=DetermineDomination(rep);
        rep=GetNonDominatedParticles(rep);
        if numel(rep)>nRep
            rep = DeleteFromRep(rep,weights,idealpoint,numOfObj,nRep);
            % rep = DeleteFromRep2(rep,weights,idealpoint,25);
        end
        
    end
    
    disp(['Iteration ' num2str(itrCounter) ': Number of Repository Particles = ' num2str(numel(rep))]);
    w=w*wdamp;
    
    if dynamic == 0
        if numOfObj == 2
            rep_costs=GetCosts(rep);
            plot(rep_costs(1,:),rep_costs(2,:),'rx');
            hold off;
        end
        if numOfObj == 3
            rep_costs=GetCosts(rep);
            plot3(rep_costs(1,:),rep_costs(2,:),...
    							rep_costs(3,:),'ko'...
                                );
            view(-243,29);
            axis square;
            grid on;
            hold off;
        end
    else
        subplot(1,2,1);
        rep_costs=GetCosts(rep);
        plot(rep_costs(1,:),rep_costs(2,:),'rx');
        hold off;
        if mod(itrCounter,window) == 0
            subplot(1,2,2);
            plot(rep_costs(1,:),rep_costs(2,:),'rx');
            hold on;
            % [rep,particle,sigmaArray] = computeSigam(rep,particle,sigmaArray);
            for ss = 1:nPop
            	particle(ss).Cost=CostFunction(particle(ss).Position);
                particle(ss).Best.Cost = CostFunction(particle(ss).Position);
        	end
        	for ss = 1:numel(rep)
        		rep(ss).Cost = CostFunction(rep(ss).Position);
    		end
    		clear ss;
        end
    end
    xlabel('Objective_1');
    ylabel('Objective_2');
    legend('Archive');
    title(['Iteration: ',num2str(itrCounter)]);
    drawnow;
    
end
costs=GetCosts(particle);
rep_costs=GetCosts(rep);
figure;
plot(costs(1,:),costs(2,:),'b.');
hold on;
plot(rep_costs(1,:),rep_costs(2,:),'rx');
legend('Main Population','Repository');
