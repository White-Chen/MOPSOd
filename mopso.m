clc;
clear;
close all;
%% Problem Definition
global colors dmethod itrCounter step window CostFunction nVar nPop niche VarMin VarMax numOfObj VarSize VelMax TestProblem dynamic idealpoint;
colors = {'bo','go','ro','co','mo','ko','bv','gv','rv','cv','mv','kv','bs','gs','rs','cs','ms','ks'};
TestProblem=38; 
dynamic = 1;
initialProblem();
dmethod = 'te';
step = 10;
window = 1000;
itrCounter = 0;
VarSize=[1 nVar]; 
VelMax=(VarMax-VarMin); 
% nPop=153;
% nRep=153;
nPop=100;
nRep=100;
MaxIt=step*window; 
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
particle = initialSwarm(particle,1,2);
[particle,weights] = init_weights(particle,numOfObj);
particle =  init_niche(particle,niche,nPop);
particle=DetermineDomination(particle); 
rep=GetNonDominatedParticles(particle); 
for itrCounter=900:MaxIt
    % DeleteFromRep2(particle,weights,idealpoint,25);
    
    for i=randperm(nPop,nPop)
        rep_h=SelectLeader(rep,particle(i),weights,numOfObj,niche);
%         rep_h=SelectLeader2(rep,i);
        if (particle(i).T <= Ta)
	        particle(i).Velocity=w*particle(i).Velocity ...
	                             +c1*rand(VarSize).*(particle(i).Best.Position - particle(i).Position)...
	                             +c2*rand(VarSize).*(rep_h.Position -  particle(i).Position);
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
%     rep=[rep
%          particle];
%     rep=DetermineDomination(rep);
%     rep=GetNonDominatedParticles(rep);
%     if numel(rep)>nRep
%         rep = DeleteFromRep(rep,weights,idealpoint,numOfObj,nRep);
%         % rep = DeleteFromRep2(rep,weights,idealpoint,25);
%     end
    disp(['Iteration ' num2str(itrCounter) ': Number of Repository Particles = ' num2str(numel(rep))]);
    w=w*wdamp;
    swarm2pic(rep);
    if mod(itrCounter,window) == 0 && dynamic == 1
        particle = initialSwarm(particle,0.2);
        [particle,rep] = reevalute(particle,rep);
    end
end
swarm2pic(rep,particle);
clearvars -except particle rep
