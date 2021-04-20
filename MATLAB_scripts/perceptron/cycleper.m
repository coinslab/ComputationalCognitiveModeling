% Script for perceptron learning

% Pick a stimulus at random
stimid = intrand(1,nstim); 
s = xmx(:,stimid);
Rdesire =  rvec(stimid); 

% Compute response of network to stimulus
Aunits = phi(W*s + bias);
Runit = phi(V*Aunits + bias);

disp(['---------------- Trial: ',int2str(trial),' --------------------']);
disp(['PREDICTED response for stimulus #',int2str(stimid),...
      ' was equal to:',int2str(Runit)]);  
disp(['CORRECT response for stimulus #',int2str(stimid),...
      ' is equal to:',int2str(Rdesire)]);

% LEARN by Changing weight vector V
V = V + gamma*(Rdesire - Runit)*Aunits';

% Provide some feedback about what is going on to modeller!
if (Runit == Rdesire), 
   disp('NO ACTION: Do not change weights since correct answer.');    
   action = 0;
end;
if (Rdesire  > Runit), 
   disp('ACTION: Add Gamma*Aunit Activities To Weights.');     
   action = 1;
end;
if (Rdesire  < Runit), 
   disp('ACTION: Subtract Gamma*Aunit Activities From Weights.');
   action = -1;
end;
disp(['---------------------------------------']);
pause(0.1);

% Evaluate overall performance of the network
dotprod = 0;
error_count = 0;
for i = 1:nstim,
   s = xmx(:,i);
   Aunits = phi(W*s + bias);
   Runit = phi(V*Aunits + bias);
   if (Runit ~= rvec(i)), error_count = error_count + 1; end;
   magR = norm(V*Aunits);
   if (magR == 0), magR = 1; end; 
   dotprod = dotprod - rvec(i)*V*Aunits/(magR*nstim); 
end;
