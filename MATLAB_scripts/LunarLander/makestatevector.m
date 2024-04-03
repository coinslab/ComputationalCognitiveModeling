function [statevector,reinforcer] = makestatevector(state,params)
% USAGE: [statevector,reinforcer] = makestatevector(state,params)

normvelocity = log(abs(state.velocity/params.objective.maxlandingvelocity))*round(state.velocity/abs(state.velocity));
normheight = log(abs(state.height/params.environment2.maxheight));
fuelinput = state.fuelinput;
% normhv1 = sqrt((1 - normheight)*abs(normvelocity));
% normhv2 = normheight*normvelocity;
landingrangeheight = (state.height < 100);
cruisingheight = (state.height < 1000);
normhv1 = landingrangeheight*normvelocity;
normhv2 = cruisingheight*normvelocity;
%statevector = [normheight normvelocity normfuel normhv1 normhv2 cruisingheight landingrangeheight 1]';
statevector = [normheight normvelocity fuelinput normheight*normvelocity fuelinput*normheight fuelinput*normvelocity fuelinput*normheight*normvelocity ...
               normhv1 normhv2 landingrangeheight cruisingheight 1]';
reinforcer = state.reinforcement;
%disp(['State Vector = ',num2str(statevector')]);

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

