function firethrusters = getuserfuelchoice(state)
% USAGE: firethrusters = getuserfuelchoice(state)
%fuelchange = 0;
% if state.fuel > 0,
    firethrusters = 0;
    userfuelchoice = input('Type the number 7 to apply thrust:');
    if ~isempty(userfuelchoice),
        if userfuelchoice == 7, % RMG 7/16/2016
            firethrusters = 1;
            disp('Applying Thrusters!');
        end;
    end;
%             state.fuelinput = state.fuelinput  + 0.1;
%         else
%             state.fuelinput = state.fuelinput  - 0.1;
%         end;
%         if (state.fuelinput < 0.0), state.fuelinput = 0.0; end;
%         if (state.fuelinput > 1.0), state.fuelinput = 1.0; end;
%    end;
% else 
%     state.fuelinput = 0;
%     disp('   ******* Out of Fuel! *******');
% end;
%disp(['User chose: ',num2str(100*state.fuelinput),' % of Maximum Thrust']);

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