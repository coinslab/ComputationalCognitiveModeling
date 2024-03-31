function demolunarlander()
% USAGE: demolunarlander;

%copyrightinfo;
disp('Lunar Lander Program. Copyright (c) 2012-2018 by Richard M. Golden');

disp('WARNING!: Using different random seed to make sequence unpredictable!');
rng('shuffle'); % apply random seed to random number generator

% disp('WARNING! Using random seed which makes sequence predictable!!!');
% rng(123); % use predictable random seed to seed generator

params = parametersetup;  % Call Function for parametersetup;
% 
% % Setup Environment Parameters
  landingpreparationtime = params.environment1.landingpreparationtime;
  maxtrajectorylength = params.environment1.maxtrajectorylength;
  nrtrajectories = params.environment1.nrtrajectories;
  initialheightmean = params.environment2.initialheightmean;
  initialheightstderror = params.environment2.initialheightstderr;
  initialvelocitymean = params.environment2.initialvelocitymean;
  initialvelocitystderror = params.environment2.initialvelocitystderr;
  initialfuel = params.environment2.initialfuel;
%  lambda = params.objective.lambda;
%  wtdecay = params.objective.wtdecay;
% extrapenalty = params.objective.penalty;
% %lambdafuel = params.objective.lambdafuel;
   momentum = params.estimation.momentum;
% 
% prompt={'Initial Fuel Amount (kg):',...
%     'Initial Height (meters):','Initial Velocity (meters/second):',...
%     'Number of Landings:',...
%     'Lambda:',...
%     'Extra Penalty for Non-SafeLanding:',...
%     'Weight Decay:',...
%     'Momentum:'};
%     
% name='Specify:';
% numlines=1;
% defaultanswer={num2str(initialfuel),num2str(initialheightmean),num2str(initialvelocitymean),num2str(nrtrajectories),...
%     num2str(lambda),num2str(extrapenalty),num2str(wtdecay),num2str(momentum)};
% answer=inputdlg(prompt,name,numlines,defaultanswer);
% 
% initialfuel = str2num(answer{1});
% params.environment2.initialfuel = initialfuel;
% initialheightmean = str2num(answer{2});
% params.environment2.initialheightmean = initialheightmean;
% initialvelocitymean = str2num(answer{3});
% params.environment.initialvelocitymean = initialvelocitymean;
% nrtrajectories = str2num(answer{4});
% params.environment.nrtrajectories = nrtrajectories;
% lambda = str2num(answer{5});
% params.objective.lambda = lambda;
% extrapenalty = str2num(answer{6});
% params.objective.penalty = extrapenalty;
% % lambdafuel = str2num(answer{7});
% % params.objective.lambdafuel = lambdafuel;
% momentum = str2num(answer{8}); % 4/15/2016
% params.estimation.momentum = momentum; % 4/15/2016


% Setup Learning Parameters
numberrecentaverage = params.estimation.numberrecentaverage;
learningrate0 = params.estimation.learningrate0; 
learningratehalflife = params.estimation.learningratehalflife;
%useexistingweights = params.estimation.useexistingweights;
initialweightrange = params.estimation.initialweightrange;
maxwtsnorm = params.estimation.maxwtsnorm;
%initialweightdownwardsthrustbias = params.estimation.initialweightdownwardsthrustbias;
%doreinforcementlearning = params.estimation.doreinforcementlearning; % rmg 12/21/2012
%docontrollearning = params.estimation.docontrollearning; % rmg 12/21/2012

% Load Training Mode
commandoptions = {'Manual Control','Autopilot-Learn','Autopilot-Learn No Fuel',...
    'Autopilot Random Control'};
[autopilotchoice,cancelmode] = listdlg('PromptString','Select Option:',...
    'SelectionMode','single','ListString',commandoptions);

% Setup Objective Function Parameters
wtdecay = params.objective.wtdecay;
lambda = params.objective.lambda;

% Setup Control Law Parameters
temp = params.objective.temp;

% Initialize learning parameters
%-----------------------------------------------------------------------------------------------------
%----------------------SET STATE DIMENSION DIMENSIONALITY -------------
statevectordim = 12;
%-----------------------------------------------------------------------------------------------------
betawts = 2*(rand(1,statevectordim)-0.5)*params.estimation.initialweightrange;

% Begin Simulation
meansoftlandinghistory = []; 
missionid = 0;
missionsoftlandinghistory = [];
initialtemp = params.objective.temp;
meansoftlandings = 0; currentmse = NaN; 
thebetawtsgrad = NaN;
for i = 1:nrtrajectories,
    clf; 
    
    % SETUP INITIAL CONDITIONS
    state2.height =     initialheightmean + initialheightstderror * (rand(1,1) - 0.5) * 2;
    state2.velocity   = initialvelocitymean + initialvelocitystderror*(rand(1,1) - 0.5) * 2;
    state2.fuel = params.environment2.initialfuel;
    state2.fuelinput = 0;
    state2.fuelvelocity = 0;
    state2.reinforcement = 0;
    plot(7,state2.height,'b^','MarkerSize',12,'LineWidth',10);
    set(gcf,'Name',['LUNAR LANDER CONTROL PANEL (Mission #',num2str(i),')']);
    set(gcf,'NumberTitle','Off');
    maxheight = params.environment2.maxheight; % graphics display height
    state2.maxheight = maxheight; % Graphics display height
    doconstantaccel = 0;
    switch autopilotchoice,
        case 1, % Manual Control
            feedbackmode = 0; autopilot = 0; learningmode = 0;
        case 2, % Autopilot-Learn
            feedbackmode = 0; autopilot = 1; learningmode = 1;
        case 3, % Autopilot-Learn No Fuel
            state2.fuel = 0;
            feedbackmode = 0; autopilot = 1; learningmode = 1;
        case 4, % Autopilot Random Control
            feedbackmode = 0; autopilot = 1; learningmode = 1; learningrate0 = 0;
%         case 5, % Autopilot Smart Control
%             feedbackmode = 0; autopilot = 1; learningmode = 1; learningrate0 = 0;
    end;
    iscale = i/learningratehalflife;
    learningrate.value = learningrate0*(1 + iscale)/(1 + iscale*iscale);
    %learningrate.alpha = learningrate.value*doreinforcementlearning; % rmg 12/21/2012
   % learningrate.beta =  learningrate.value*docontrollearning; % rmg 12/21/2012
    learningrate.beta = learningrate.value; % rmg 5/27/2016
   % params.control.temp = initialtemp/(1 + (i*iscale));
    temp = params.objective.temp;
 
    msei = 0; mse1 = nan; perferror = 0; 
    dtlast = inf*betawts(:); % 4/15/2016
    axis([0 30 0 maxheight]);
    text(4,10000,'Begin Lunar Module Descent!!','FontSize',20,'LineWidth',8);
    t = 0; abortmission = 0; deltaalpha = 0; deltabmx = 0; deltamse = 0;
    gradmaxi = 0; % rmg 12/26/2012
    while ~abortmission,
        t = t + 1; 
        state2.time = t*params.environment1.timestep;
        state0 = state2;
        %disp(['Time = ',num2str(state0.time),' seconds.']);
        [state1,u0,pu0] = updatestate(state0,betawts,params,autopilotchoice,feedbackmode,meansoftlandings,currentmse);
        [state2,u1,pu1] = updatestate(state1,betawts,params,autopilotchoice,feedbackmode,meansoftlandings,currentmse);
        if learningmode,
            [thebetawtsgrad,perferror] = gradbetawts(betawts,state0,state1,state2,u0,u1,pu0,pu1,feedbackmode,params); % 4/14/2016
            inversedtlast = 1/(norm(dtlast)*norm(dtlast)); themargin = 0.1;
            if (momentum < (1-themargin)*inversedtlast) & (momentum > themargin*inversedtlast),
                dt = -thebetawtsgrad + momentum*dtlast;
            % disp('momentum step');
            else
              %  disp('gradient-step');
                dt = -thebetawtsgrad;
            end;
            betawts = betawts + learningrate.beta*dt;
            dtlast = dt;
        end;
        %msei = (mse0 + mse1)/2;
        msei = perferror; % 4/14/2016
        toolongtrajectory = (t > maxtrajectorylength);
        normwts = norm(betawts(:));
        weightstoolarge = normwts > maxwtsnorm;
        haslanded = state2.landed;
        abortmission = state2.escapedorbit | toolongtrajectory | haslanded | weightstoolarge;
        if abortmission,
            missionsoftlandinghistory = [missionsoftlandinghistory; state2.softlanding];
            meansoftlandings = 100*mean(missionsoftlandinghistory);
            meansoftlandinghistory = [meansoftlandinghistory; meansoftlandings];
            missionid = missionid + 1;
            missionvelocityhistory(i) = abs(state2.velocity);
            
            if ((i+1) <= numberrecentaverage),
                meanmissionvelocity(missionid) = mean(missionvelocityhistory(1:i));
            else
                meanmissionvelocity(missionid) = mean(missionvelocityhistory(i-numberrecentaverage+1:i));
            end;
            msehistory(i) = msei;
            meanmse(i) = mean(msehistory(1:i));
            currentmse = meanmse(i);
            gradmaxi = max(abs(thebetawtsgrad));
            gradmaxhistory(i) = gradmaxi; % RMG 12/26/2012
            if state2.softlanding, 
                statusinfo = 'SUCCESSFUL Landing! ';
            else
                statusinfo = 'FAILED Landing! ';
            end;
            disp('------------------------------------------');
            disp([statusinfo, 'Lunar landing mission #',num2str(missionid)]);
            simulationtime = t;
            disp(['Learning Trajectory #',num2str(i),' of ',num2str(nrtrajectories),'. Elapsed Time:',num2str(simulationtime),' seconds.']);
            disp(['Learning Rate (beta) = ',num2str(learningrate.beta)]);
            disp(['Landing Height = ',num2str(state2.height),', Landing Velocity = ',num2str(state2.velocity)]);
            disp(['Performance Index = ',num2str(currentmse),', % of Soft Landings = ',num2str(meansoftlandings),', Mean Landing Velocity = ',num2str(meanmissionvelocity(missionid))]);
            %disp(['Alpha Wts:',num2str(alphawts)]);
            disp(['Beta Wts: ',num2str(betawts)]);       
            pause(landingpreparationtime);
        end;
    end;
    landingstate = state2;
end;

if learningmode,
    figure;
    subplot(1,4,1); plot(meanmissionvelocity);
    title('Mission History');
    ylabel('Landing Velocity');
    xlabel('Learning Trials');
    subplot(1,4,2); plot(meanmse);
    ylabel('Performance Index');
    xlabel('Learning Trials');
    subplot(1,4,3); plot(meansoftlandinghistory);
    ylabel('% Soft Landings');
    xlabel('Mission Number');
    subplot(1,4,4); plot(gradmaxhistory); % RMG 12/26/2012
    ylabel('Grad Max'); % RMG 12/26/2012
    xlabel('Learning Trials');  % RMG 12/26/2012
    disp(['Final GradMAX = ',num2str(gradmaxhistory(i))]); % RMG 12/26/2012
end;
save('missiondata');
%save('weights','alpha','bmx');

%-----------------------------------------------------------------------------
% Lunar Lander Software (located in folder "LunarLander")
%
%Copyright 2015-2016  RMG Consulting, Incorporated
%
%Licensed under the Apache License, Version 2.0 (the "License");
%you may not use this file except in compliance with the License.
%You may obtain a copy of the License at
%
%       http://www.apache.org/licenses/LICENSE-2.0
%
%Unless required by applicable law or agreed to in writing, software
%distributed under the License is distributed on an "AS IS" BASIS,
%WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%See the License for the specific language governing permissions and
%limitations under the License.
%
%
% "RMG Consulting, Incorporated" is located in Allen, TX 75013
%
% Tutorial videos, software updates, and software bug fixes located at: 
% www.learningmachines101.com
%-------------------------------------------------------------------------------
