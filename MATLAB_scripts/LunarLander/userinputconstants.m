function constants = userinputconstants(dialogboxname,constants,vartypes,varprompts);
%USAGE: constants =  userinputconstants(dialogboxname,constants,vartypes,varprompts);

numlines=1; numprecision = 10;
options.Resize='on';
options.WindowStyle='normal';
options.Interpreter='tex';
fieldchoice = fieldnames(vartypes);
nrfields = length(fieldchoice);
for i = 1:nrfields,
    %variablei = getfield(constants,fieldchoice{i});
    vartypei = getfield(vartypes,fieldchoice{i});
    varpromptlist{i} = getfield(varprompts,fieldchoice{i});
    nrvariablevalues = length(vartypei);
    isnumericalvar = (nrvariablevalues == 1);
    isstringvar = (nrvariablevalues == 0);
    isstringdialog = (nrvariablevalues > 1);
    defaultanswerstring = '';
    if isnumericalvar,
        if isfield(constants,fieldchoice{i}),
            defaultanswerstring = getfield(constants,fieldchoice{i});
        end;
        variabledefaultanswer{i} = num2str(defaultanswerstring,numprecision);
    end;
    if isstringdialog,
        % Categorical Variable Case
        varprompti = getfield(varprompts,fieldchoice{i});
        if isfield(constants,fieldchoice{i}),
            defaultanswerstring = getfield(constants,fieldchoice{i});
        end;
        defaultselection = strmatch(defaultanswerstring,vartypei,'exact');
        [selectionchoice,okchoice] = listdlg('PromptString',varprompti,...
                      'SelectionMode','single','ListString',vartypei,...
                      'ListSize',[300 300],'InitialValue',defaultselection);
        userchoicestring = vartypei{selectionchoice};
        constants = setfield(constants,fieldchoice{i},userchoicestring);
        variabledefaultanswer{i} = userchoicestring;
    end;
    if isstringvar,
        if isfield(constants,fieldchoice{i}),
            defaultanswerstring = getfield(constants,fieldchoice{i});
        end;
        variabledefaultanswer{i} = defaultanswerstring;
    end;
end;
answer=inputdlg(varpromptlist,dialogboxname,numlines,variabledefaultanswer,options);
for i = 1:nrfields,
    vartypei = getfield(vartypes,fieldchoice{i});
    nrvariablevalues = length(vartypei);
    isnumericalvar = (nrvariablevalues == 1);
    isstringvar = (nrvariablevalues == 0);
    isstringdialog = (nrvariablevalues > 1);
    if isnumericalvar,
        finalvalue{i} = str2num(answer{i});
    end;
    if isstringdialog,
        finalvalue{i} = answer{i};
    end;
    if isstringvar,
        finalvalue{i} = answer{i};
    end;
    constants = setfield(constants,fieldchoice{i},finalvalue{i});
end

