function [newstate,firethrusters,thrustprob] = updatestate(state,betawts,params,autopilot,feedbackmode,meansoftlandings,currentmse)
% USAGE: [newstate,firethrusters,thrustprob] = updatestate(state,betawts,params,autopilot,feedbackmode,meansoftlandings,currentmse)

% Constants
timestep = params.environment1.timestep;
maxlandingvelocity = params.objective.maxlandingvelocity;
landingheight = params.objective.maxlandingheight; % meters
%maxheight = params.environment.maxheight;
escapevelocity = params.environment2.escapevelocity;
realtimeincrement = params.environment1.realtimeincrement;
displaythrustprob = params.display.displaythrustprob;
lunarthrust = params.environment2.lunarthrust;
fuelefficiency = params.environment2.fuelefficiency;
glunar = params.environment2.glunar;
masslander = params.environment2.masslander;
temp = params.objective.temp;
state.reinforcement = 0;
initialvelocity = params.environment2.initialvelocitymean;
initialheight = params.environment2.initialheightmean;
%landingvelocitymargin = params.environment.landingvelocitymargin;

firethrusters = 0; thrustprob = 0;
switch autopilot,
    case 1,
        if state.fuel > 0, % 7/16/2016
            firethrusters = getuserfuelchoice(state); % 7/16/2016
        %firethrusters = state.fuelinput; % 7/16/2016
        end;
%     case 5,
%         constantaccel = 0;
%         if state.height > 0,
%            futureheight = state.height - state.velocity*timestep;
%            correctedheight = (state.height + futureheight)/2;
%            currentaccel = (0.5)*state.velocity*state.velocity/correctedheight;  
%            % constantaccel = (0.5)*initialvelocity*initialvelocity/initialheight;
%         end;
%         firethrusters = -(currentaccel - glunar)*(masslander + state.fuel)/lunarthrust;
%         if firethrusters > 1, firethrusters = 1; end;
%         if firethrusters < 0, firethrusters = 0; end;
%         state.fuelinput = firethrusters;
     otherwise,
        if state.fuel > 0,
            [fuelinput,firethrusters,thrustprob] = anncontrol(state,betawts,temp,params);
            %state.fuelinput = fuelinput; % 7/16/2016
        end;
end;

% UPDATE System State Vector 
acceleration = glunar - firethrusters*lunarthrust/(masslander + state.fuel);
statevelocity = (state.velocity + timestep*acceleration);
stateheight = (state.height  - timestep*state.velocity);
fuelvelocity = lunarthrust*firethrusters/fuelefficiency;
statefuel = (state.fuel - timestep*fuelvelocity);

% Check if Landed
state.landed = (stateheight < landingheight);

% Check if Target Achieves
state.targetachieved = state.landed & (statevelocity < maxlandingvelocity);

% Check if Soft Landing
state.softlanding = state.landed & (statevelocity < maxlandingvelocity);

% Check if Crash Landing
state.crashlanding = state.landed & (statevelocity >=  maxlandingvelocity);

% Check if escaped orbit
state.escapedorbit = (stateheight > params.environment2.heightescapevelocity) | (statevelocity < -params.environment2.escapevelocity);

% % Generate Reinforcement Signal
% if state.softlanding,
%     state.reinforcement = params.objective.softlandingreward;
% end;
% if state.escapedorbit,
%     state.reinforcement = params.objective.escapeorbitpenalty;
% end;
% if state.crashlanding,
%     state.reinforcement = params.objective.crashlandingpenalty;
% end;

% UPDATE System State Vector 
state.velocity = statevelocity;
state.height = stateheight;
state.fuel = statefuel * (state.fuel > 0);

% Move Lander and Display Results
movelander(state,feedbackmode,params,meansoftlandings,currentmse,firethrusters); % rmg 7/16/2016
pause(realtimeincrement); % PAUSE 1/10 of a second
newstate = state;


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