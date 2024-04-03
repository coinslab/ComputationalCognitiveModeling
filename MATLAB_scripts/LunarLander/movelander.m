function movelander(state,feedbackmode,params,meansoftlandings,currentmse,firethrusters)
% USAGE: movelander(state,feedbackmode,params,meansoftlandings,currentmse,firethrusters)
% 
% INPUTS:
%     state.height    Number of feet above ground
%     state.velocity  Feet Per Second Descent Velocity
%     state.crashlanding 1=vehicle just crashed, 0=if has not crashed
%     state.softlanding 1=vehicle just landed softly, 0=if not landed
%     state.fuel      Number of fuel units available (used for display)
%     fuelinput       amount of fuel units to be applied 
%     feedbackmode    1=get user feedback, 0=do not get userfeedback
%

% Constants
state.crashlanding = ~state.softlanding & state.landed;
fuelinput = state.fuelinput;
thrust = params.environment2.lunarthrust;

% Update Display for Crash Landing Case
if state.crashlanding,
    plot(7,1,'r*','MarkerSize',100,'LineWidth',3);
    hold on;
    plot(7,1,'b>','MarkerSize',12,'LineWidth',10);
    ylabel('Height (meters)','FontSize',20);
    hold on;
    text(4,6000,'CRASH!!','FontSize',40,'LineWidth',8);
    hold on;
end;

% Update Display for Soft Landing Case
if state.softlanding,
    plot(7,1,'b^','MarkerSize',12,'LineWidth',10);
    ylabel('Height (meters)','FontSize',20);
    hold on;
    text(4,6000,'Good Landing!!','FontSize',40,'LineWidth',8);
    hold on;
end;

% Update Display for Escape Velocity Case
if state.escapedorbit,
    plot(7,1,'b^','MarkerSize',12,'LineWidth',10);
    ylabel('Height (meters)','FontSize',20);
    hold on;
    text(1,6000,'Abort: Divergence from Flight Plan!','FontSize',20,'LineWidth',8);
    hold on;
end;

% Update Display for Descent Case
if ~state.landed,
    plot(7,state.height,'b^','MarkerSize',12,'LineWidth',10);
    ylabel('Height (meters)','FontSize',20);
    hold on;
    %streamlength = state.height - 2000*fuelinput;
    streamlength = state.height - 2000*(0.5)*firethrusters;
    fuelinput = 1; % rmg 7/16/2016
    
    % Draw Thrusters
    if abs(fuelinput) > 0 & (state.fuel > 0),
        if fuelinput > 0, 
            thrustvector = [streamlength, state.height - 200];
        else
            thrustvector = [state.height + 200, streamlength];
        end;
        plot([7 - 0.5, 7 - 0.5],thrustvector,'g-',...
                [7 , 7],thrustvector,'g-',...
                [7+0.5, 7 + 0.5],thrustvector,'g-','LineWidth',3);
    end;
    if feedbackmode,
       userfeedback = input('W=Watch out!, K=OK, Enter=No Comment:','s');
       if isempty(userfeedback),
           feedback = 0;
       else
           if strcmp(lower(userfeedback),'w'),
               feedback = -1;
           else
               feedback = 1;
           end;
       end;
   end;
end;

% Setup Plot Display
axis([0 30 0 state.maxheight]);
set(gca,'FontSize',14); % Change size of axis numbering
if (state.height > 0),
    acceleration = (0.5)*state.velocity*state.velocity/state.height;
else
    acceleration = 0;
end;
 
% RMG 1/3/2017 deleted "thrust display" in following line of code. 
statusinfo = strvcat(['Fuel: ',num2str(state.fuel),' kg'],['Height: ', num2str(state.height),' m'],...
    ['Velocity: ',num2str(state.velocity),' m/sec'],...
    ['Acceleration:',num2str(acceleration),'m/sec^2'],...
    ['Seconds: ',num2str(state.time),' seconds'],...
    ['% Soft Landings = ',num2str(meansoftlandings)],['Performance Index = ',num2str(currentmse)]);

text(12,state.maxheight-4000,statusinfo,'FontSize',14,'LineWidth',4);
hold off;
end


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
