function [fuelinput,thrusterchoice,thrusterprob] = anncontrol(state,betawts,temp,params);
% USAGE: [fuelinput,thrusterchoice,thrusterprob] = anncontrol(state,betawts,temp,params);

% INPUTS: state (structure indicating system state)
%         betawts (parameter column vector)
%         temp  (positive number, temp = small positive number
%                gives deterministic control while large positive
%                number gives random behavior)
%
% OUTPUT: thrusterprob is a scalar indicating probability that
%         the engines willl fire at this instant in time.

statevector = makestatevector(state,params);
netinput = (betawts*statevector)/temp;
thrusterprob = 1/(1+exp(-netinput));

% Compute Thruster Level
arandomnumber = rand(1,1);
thrusterchoice = thrusterprob > arandomnumber;

% if thrusterchoice == 1,
%     fuelinput = state.fuelinput + 0.1;
% else
%     fuelinput = state.fuelinput - 0.1;
% end;
% %fuelinput = thrusterchoice;  % RMG 6/13/2016 6:30pm  % CHECK THIS!!!!
% if (fuelinput < 0.0), fuelinput = 0.0; end;
% if (fuelinput > 1.0), fuelinput = 1.0; end;
fuelinput = []; % 7/16/2016

% NOTE (7/16/2016): In the current implementation, I do not think
% "fuelinput" or "state.fuelinput is used!!

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
