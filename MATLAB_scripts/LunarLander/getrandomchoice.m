function prob_choice = getrandomchoice(prob)
% USAGE: prob_choice = getrandomchoice(prob)
% prob_choice = getrandomchoice(prob) where prob is a probability vector
% This routine assumes all elements of prob are non-negative and add up to one.
probdim = length(prob);
prob(1) = 1 - sum(prob(2:probdim));
the_randnum = rand(1,1);
SumP = 0; prob_choice = 0; i  = 1;
while (prob_choice == 0),
    SumNext = SumP + prob(i); 
    if (the_randnum >= SumP) & (the_randnum < SumNext), 
		prob_choice = i;
%                  disp(['the_randnum = ',num2str(the_randnum),'     SumP = ',num2str(SumP),...
%				    '   SumNext = ',num2str(SumNext),'   Probchoice = ',num2str(prob_choice)]);
    end;
    SumP = SumNext;
    i = i + 1;
end;
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