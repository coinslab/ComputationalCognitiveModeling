%FILE: stimuli.m
% Specify the training stimuli here
% In this example, there are four training
% stimuli. Stimulus X1 is the input stimulus #1
% whose desired response is R1...and so on.

disp('Example Stimulus Set Where the SOLUTION IS LIKELY TO EXIST');
goon = input('type any key to continue','s');
%Example Stimulus Set where third unit is a "bias" unit
x1 = [-1  -1  1]; R1 = -1;
x2 = [-1   1  1]; R2 = 1;
x3 = [ 1  -1  1]; R3 = 1;
x4 = [ 1   1  1]; R4 = 1;

% Once you have defined all of your training
% stimuli and their respective desired responses
% you need to put them into the following two matrices
% for the program to work correctly.
xmx = [x1' x2' x3' x4']
rvec = [R1 R2 R3 R4] 
