function [thebetawtsgrad,errorval] = gradbetawts(betawts,state0,state1,state2,u0,u1,pu0,pu1,feedbackmode,params);

[s0,r0] = makestatevector(state0,params);
[s1,r1] = makestatevector(state1,params);
[s2,r2] = makestatevector(state2,params);

lambda = params.objective.lambda;
lambdavelocitymag = params.objective.lambdavelocitymag; % doesn't make sense so set to zero.
wtdecay = params.objective.wtdecay;
%lambdafuel = params.objective.lambdafuel;
dpu0dbeta = (u0 - pu0)*s0';
dpu1dbeta = (u1 - pu1)*s1';

endtrajectory2 = state2.landed | state2.escapedorbit;
finalvelocitymag = sqrt(s1(2)*s1(2) + s2(2)*s2(2))*endtrajectory2;
crashpenalty = state2.crashlanding * params.objective.penalty;
velocitymag = sqrt(s2(2)*s2(2) + s1(2)*s1(2));
smoothnessmag = sqrt((s1(1) - s2(1))*(s1(1) - s2(1)) + (s1(2) - s2(2))*(s1(2) - s2(2)));
wtdecaymag = wtdecay*0.5*norm(betawts)*norm(betawts);
errorval = (  crashpenalty + finalvelocitymag + lambdavelocitymag*velocitymag + lambda*smoothnessmag + wtdecaymag);
thebetawtsgrad = errorval *(dpu0dbeta + dpu1dbeta) + wtdecay*betawts;
% IMPORTANT: Note this implements what is in the book when wtdecay = 0.

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
    
  