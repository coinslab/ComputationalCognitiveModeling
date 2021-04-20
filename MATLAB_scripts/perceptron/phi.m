%FILE: phi.m
function y = phi(x)
dim = max(size(x));
y = x;
for i = 1:dim,
   if (x(i) >= 0), y(i) =  1; end;
   if (x(i) < 0),  y(i) = -1; end;
end;
