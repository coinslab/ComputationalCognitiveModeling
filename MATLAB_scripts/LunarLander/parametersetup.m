function params = parametersetup;
% USAGE: params = parametersetup;

setdefaultvalues = 1;
if ~exist('params.mat'),
    disp('File "params.mat" not found. Using default Values.');
else
    ButtonName = questdlg('DELETE existing default constants?:',...
        'Default Constants','Yes','No','No');
    if strcmp(ButtonName,'Yes'),
        delete('params.mat');
        disp('"params.mat" has been deleted.');
    else
        setdefaultvalues = 0;
        disp('File "params.mat" found. Using Current Values.');
        load('params.mat');
    end;
end;

% Set default values
if setdefaultvalues,
    params.objective.wtdecay = 0.01; % 0.0001 % 0.01; % 0.10; % 0.01;
    params.objective.lambda = 0.1% 0.4; % 0.4; % 0.2; % 0.01; % 0.2; %0.2; %0.5; % 0.2 0.5<----------------------------------------------------
    params.objective.lambdavelocitymag = 0; % added 10/12/2019  838am
    params.objective.maxlandingvelocity = 25; %30; %35 m/s (35% soft landings) (4/17); <----------------------------------------------------
    params.objective.maxlandingheight = 0; % meters   %20 meters
    params.objective.penalty = 1; % 1; % 4/17/2016
    params.objective.temp = 1.0; % 5/27/2016 modified params structure
    params.environment1.nrtrajectories =  100; %1000;
    params.environment1.timestep = 1; % simulation stepsize in seconds
    params.environment1.realtimeincrement = 0.0001; % (seconds in real time) % physically slows simulation
    params.environment1.maxtrajectorylength =  2000; % 
    params.environment1.landingpreparationtime = 1; % (seconds in real time) % physically slows simulation
    params.environment2.initialvelocitymean = 100; %150 % meters/second
    params.environment2.initialvelocitystderr = 20; % meters/second 
    params.environment2.initialheightmean = 15000; % meters
    params.environment2.initialheightstderr = 10; % meters was 20 
    params.environment2.initialfuel = 3500; %4000; %3500 % 4000; % 3000 (4/17/2016) ; % kilograms <----------------------------------------------------
    params.environment2.escapevelocity = 25; %50; % meters/second  % original 50
    params.environment2.heightescapevelocity = 15000; %meters (realistic number is 110000)
    params.environment2.fuelefficiency = 2300;                               ; % meters/second
    params.environment2.glunar = 1.63; % m/sec^2 (lunar gravitational acceleration)
    params.environment2.lunarthrust = 25000; %25000; %30000; %25000; % meters-kg/sec^2 
    params.environment2.masslander = 4000; % kg
    params.estimation.initialweightrange = 0.0001; %0.0001
    nrtrajectories = params.environment1.nrtrajectories;
    params.estimation.learningrate0 = 0.01; % 0.01; % 0.001; %0.001; % 11/18/2015
    params.estimation.momentum = 0.0; %0.3; %0.5; % 4/15/2016
    params.estimation.learningratehalflife = ceil(nrtrajectories/2);
    params.estimation.maxwtsnorm = 15; % abort if magnitude of weights exceeds this value
    params.estimation.numberrecentaverage = 100; % Average over these last number of trajectories 
end;


% Setup Parameters for Objective Function
varprompt.objective.wtdecay = 'Weight Decay?:';
vartype.objective.wtdecay = {[0,inf]};
varprompt.objective.lambda = 'Regularization Term Weight Lambda?:';
vartype.objective.lambda = {[0,inf]};
varprompt.objective.lambdavelocitymag = 'Regularization Velocity Mag (set to 0..dont use)?'; % 10/12/2019
vartype.objective.lambdavelocitymag = {[0,inf]}; % 10/12/2019

varprompt.objective.maxlandingvelocity = 'Maximum Soft Landing Velocity (m/s)?:';
vartype.objective.maxlandingvelocity = {[0,inf]};
%params.objective.lambdafuel = 0; Commented out 5/27/2016
%params.environment.landingvelocitymargin = 5; % April 17 <------------------- safe landing is less than maxlanding velocity + margin

varprompt.objective.maxlandingheight = 'Maximum Soft Landing Height (m)?:';
vartype.objective.maxlandingheight = {[0,inf]};

varprompt.objective.penalty = 'Additional Penalty for Crash Landing?:';
vartype.objective.penalty = {[0,inf]};

varprompt.objective.temp = 'Control Law Temperature Parameter?:';
vartype.objective.temp = {[0,inf]};
%params.objective.thrustmultiplier = 1;  % ****** DELETED MAY 27, 2016 ****
%params.objective.escapeorbitpenalty = 100; % this is hardwired to equal "crashlandingpenalty" in updateweights.m" 
% params.objective.softlandingreward =  -100; 
% params.objective.crashlandingpenalty = 100; 


% Update Model Constants Structure
params.objective = userinputconstants('OBJECTIVE',params.objective,vartype.objective,varprompt.objective);

% Setup Parameters for Statistical Environment (Part 1)

varprompt.environment1.nrtrajectories = 'Maximum Number of Mission Trajectories?:';
vartype.environment1.nrtrajectories = {[0,inf]};

varprompt.environment1.timestep = 'Virtual Time in Seconds Per Simulation Step?:';
vartype.environment1.timestep = {[0,inf]};

varprompt.environment1.realtimeincrement = 'Real-World Time in Seconds Between Simulation Steps?:';
vartype.environment1.realtimeincrement = {[0,inf]};

varprompt.environment1.maxtrajectorylength = 'Maximum Time Steps Per Mission Trajectory?:';
vartype.environment1.maxtrajectorylength = {[0,inf]};

varprompt.environment1.landingpreparationtime = 'Real-World Time Delay in Seconds Between Missions?:';
vartype.environment1.landingpreparationtime = {[0,inf]};

% Update Environment 1 parameters data structure
params.environment1 = userinputconstants('ENVIRONMENT-1',params.environment1,vartype.environment1,varprompt.environment1);

% SETUP PARAMETERS FOR STATISTICAL ENVIRONMENT (Part 2)
varprompt.environment2.initialvelocitymean = 'Initial Mean Lander Velocity (m/s)?:';
%params.environment2.initialvelocitymean = 20; 
vartype.environment2.initialvelocitymean = {[0,inf]};

varprompt.environment2.initialvelocitystderr = 'Initial Std.Dev. Lander Velocity (m/s)?:'; 
%params.environment2.initialvelocitystderr = 0.001;
vartype.environment2.initialvelocitystderr = {[0,inf]};

varprompt.environment2.initialheightmean = 'Initial Mean Lander Height (meters)?:';
vartype.environment2.initialheightmean = {[0,inf]};

varprompt.environment2.initialheightstderr = 'Initial Std. Dev. Lander Height (meters)?:';
%params.environment2.initialheightstderr = 0.001;
vartype.environment2.initialheightstderr = {[0,inf]};

varprompt.environment2.initialfuel = 'Initial Fuel in Lander (kilograms)?:';
%params.environment2.initialfuel = 1000;
vartype.environment2.initialfuel = {[0,inf]};

varprompt.environment2.escapevelocity = 'Minimum Upwards Velocity to Abort?:';
vartype.environment2.escapevelocity = {[0,inf]};
%params.environment.heightescapevelocity = params.environment.maxheight*1.5; % meters

varprompt.environment2.heightescapevelocity = 'Minimum Height Criteria to Abort?:';
vartype.environment2.heightescapevelocity = {[0,inf]};

varprompt.environment2.fuelefficiency = 'Fuel Efficiency Factor (m/s)?:';
vartype.environment2.fuelefficiency = {[0,inf]};

varprompt.environment2.glunar = 'Lunar Gravitational Acceleration (m/sec^2)?:';
vartype.environment2.glunar = {[0,inf]};

varprompt.environment2.lunarthrust = 'Thrust Output of Lander (meters-kg/sec^2)?:'; 
vartype.environment2.lunarthrust = {[0,inf]};

varprompt.environment2.masslander = 'Mass of Lunar Lander (kg)?:';
vartype.environment2.masslander = {[0,inf]};
%params.environment.maxvelocity = 1000; % meters/second;

%params.environment.maxfuel = 20000; % kilograms
%params.environment.maxfuelvelocity = 100; % kilograms/second

% Update Environment 2 parameters data structure
params.environment2 = userinputconstants('ENVIRONMENT-2',params.environment2,vartype.environment2,varprompt.environment2);

% Compute Initial Conditions
% h0 = state.height; v0 = state.velocity; a0 = (0.5)*v0*v0/h0; 
% masslander = params.environment2.masslander; 
% MaxThrust = params.environment2.lunarthrust; mtotal = masslander;
% badinitialconditions = (h0/(v0*v0)) > 0.5/(( MaxThrust/mtotal)+glunar);


% Setup Parameters for Learning Algorithm
varprompt.estimation.initialweightrange = 'Initial Random Weight Range?:';
vartype.estimation.initialweightrange = {[0,inf]};

%params.estimation.batchlearning = 0; % 0 or 1
%params.estimation.learningrate0 =  0.0001; % 0.001

varprompt.estimation.learningrate0 = 'Initial Learning Rate?:';
vartype.estimation.learningrate0 = {[0,inf]};

varprompt.estimation.momentum = 'Momentum Search Direction Parameter?:';
vartype.estimation.momentum = {[0,inf]};

varprompt.estimation.learningratehalflife = 'Learning Rate Half Life?:';
vartype.estimation.learningratehalflife = {[0,inf]};

%params.estimation.useexistingweights = 0;
varprompt.estimation.maxwtsnorm = 'Max. Weight Norm for Simulation Abort?:';
vartype.estimation.maxwtsnorm = {[0,inf]};

%params.estimation.maxwtsnormrescalefactor = 0.1;
%params.estimation.initialweightdownwardsthrustbias = -1;
%params.estimation.doreinforcementlearning = 1; % rmg 12/21/2012
%params.estimation.docontrollearning = 1; % rmg 12/21/2012

varprompt.estimation.numberrecentaverage = 'Average Performance Measure Time Period?:';
vartype.estimation.numberrecentaverage = {[0,inf]};
%params.estimation.doreinforcementlearning = 0; % rmg 12/21/2012
%params.estimation.docontrollearning = 0; % rmg 12/21/2012

% Update estimation parameters data structure
params.estimation = userinputconstants('ESTIMATION',params.estimation,vartype.estimation,varprompt.estimation);

% Setup Display Parameters
params.display.displaythrustprob = 1;
params.environment2.maxheight = params.environment2.initialheightmean; % This sets the GRAPHICS DISPLAY HEIGHT!
save('params.mat','params');
disp('Updated Constants for Lunar Lander Simulator Saved to "params.mat"');
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

