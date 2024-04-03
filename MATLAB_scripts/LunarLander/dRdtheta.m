function [dRdalpha,dRdBmx] = dRdtheta(state,bmx,alpha,temp,thrusterprob)
% USAGE: [dRdalpha,dRdBmx] = dRdtheta(state,bmx,alpha,temp,thrusterprob)

% Compute Thrusterprob if necessary
if isempty(thrusterprob),
    thrusterprob = anncontrol(state,bmx,temp);
end;

% compute dRdalpha
normheight = state.height/state.maxheight;
normvelocity = state.velocity/state.nominalvelocity;
thrusterprob = anncontrol(state,bmx,temp);
inputvector = [1 normheight normvelocity thrusterprob']';
dRdalpha = inputvector';

% Computed dRdbmx
eyemx = eye(3);
dPdPsi = diag(thrusterprob) - thrusterprob*thrusterprob';
stateinfo = [normheight normvelocity 1];
dPsidBrow = [0 0 0; stateinfo; stateinfo];
alphavec = alpha(4:6);
alpharow456 = (alphavec(:))';
dRdBmx(1,:) = alpharow456 * dPdPsi * eyemx(:,2)*stateinfo;
dRdBmx(2,:) = alpharow456 * dPdPsi * eyemx(:,3)*stateinfo;
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

