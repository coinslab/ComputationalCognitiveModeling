%FILE: percept.m
% THIS IS THE MAIN PROGRAM FOR RUNNING THE PERCEPTRON PROGRAM

% Seek out and Destroy old figure windows
oldfighandles = findobj('Tag','NeuralNetViewer');
for i = 1:length(oldfighandles),
    delete(oldfighandles(i));
end;

% Create Figure Window


disp('************************ PERCEPTRON SIMULATION PROGRAM ********************');
% GET PARAMETERS FROM THE USER
gamma = input('Learning rate (e.g., 1.0)?:');
nr_trials = input('How many learning trials (e.g., 10)?:');

stimfilename = input('Name of stimulus  file without ".m" suffix (e.g., "orstimuli")?:','s');
eval(stimfilename);

%startnew = input('Is this a new simulation run?(1=yes,0=no)?:');
startnew = 1;
if startnew,
	% Set up the Perceptron
    % bias = input('Input Unit Bias (e.g., -1):');
      bias = -1;
    % wrange = input('Range of initial weights?(-wrange to +wrange) (e.g., 1):');
      wrange = 1;
	Adim = input('Number of hidden units (i.e., "A-units")? (e.g., 10):');
    [Sdim,nstim] = size(xmx); 
	cont = input('Please hit the return key to continue.','s');
	disp('  ');
	disp('W is the connectivity matrix from the S-units to the A-units:');
	W = wrange*(2*rand(Adim,Sdim) - 1)
    %dohandwire = input('Do you want to change ("handwire") W? (1=yes,0=no):');
    dohandwire = 0;
    if dohandwire,
        disp('Please type in a new W connectivity matrix!');
        disp('When you are finished, type the command "return" at MATLAB prompt like this:');
        disp('>>return');
        keyboard;
    end;
	disp('  ');
	disp('V is the connectivity matrix from the A-units to the R-unit:');
	V =zeros(1,Adim)
	cont = input('Please hit the return key to continue.','s');
	act_history = [];
	error_history =[];
	dotp_history = []; 
end;
fighandle = figure;
set(fighandle,'Position',[150 300 600 500]);
set(fighandle,'Name','PERCEPTRON Simulator View Window');
set(fighandle,'NumberTitle','Off');
set(fighandle,'Tag','NeuralNetViewer');
for trial = 1:nr_trials, 
	cycleper;
        error_history = [error_history; error_count];
        dotp_history = [dotp_history; dotprod];
        act_history = [act_history; action]; 
	subplot(221); 
	plot(error_history);
        ylabel('Errors');
        xlabel('Learning Trials');
        title(['Error History']);
	subplot(222); 
	plot(dotp_history);
        ylabel('Energy (-Dot Product)');
        xlabel('Learning Trials');
        title(['Dot Product History']);
        subplot(223)
	bar(V);
        title('A-unit to R-unit Weights'); 	
        ylabel('Weight Value');
	xlabel('Weight Identification #');
	subplot(224)
        bar(act_history); 
	title('Action History');
	ylabel('Weight Change Increment');
        xlabel('Learning Trials');	
        pause(0.2); 
end;
