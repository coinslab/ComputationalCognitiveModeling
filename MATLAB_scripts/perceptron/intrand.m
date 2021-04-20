%FILE: intrand.m
function y = intrand(xbeg,xend)
y = round(rand(1,1)*(xend - xbeg) + xbeg);
