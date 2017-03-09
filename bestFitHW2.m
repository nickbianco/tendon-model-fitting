function [alpha,beta,Etan0,Etan20,T_fit] = bestFitHW2(lmda,T)

p_init = [0.1 0.1];
p_fit = fminsearch(@(p) costfun(p,@model,lmda,T),p_init);

alpha = p_fit(1);
beta = p_fit(2);
Etan0 = tanmod(alpha,beta,1);
Etan20 = tanmod(alpha,beta,1.2);

T_fit = model(p_fit,lmda);

end

function [T] = model(p,lmda)

a = p(1);
b = p(2);
T = a*(exp(b*(lmda-1)) - 1);

end

function [err] = costfun(p,model,xdata,ydata)

yfit = model(p,xdata);

err = sum((ydata-yfit).^2);

end

function [Etan] = tanmod(a,b,lmda)

Etan = a*b*exp(b*(lmda-1)); 

end