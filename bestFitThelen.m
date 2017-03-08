function [eToe,fToe,kToe,kLin] = bestFitThelen(lmda,F_tilde,X,Y)

% Initial guesses
eIso = X(1)-1;
kIso = 1.375/eIso;
fToe = Y(2);
curviness = 0.5;

options = optimoptions('fmincon','Display','iter-detailed');
problem.options = options;
problem.solver = 'fmincon';
problem.objective = @(p) myfun(p,@model,lmda,F_tilde);
problem.x0 = [eIso kIso fToe curviness];
problem.lb = [eIso-0.025 kIso-5 Y(2)-0.2 0];
problem.ub = [eIso+0.025 kIso+5 Y(2)+0.2 1];
problem.nonlcon = @mycon;

p_fit = fmincon(problem);

eIso = p_fit(1);
kIso = p_fit(2);
fToe = p_fit(3);
curviness = p_fit(4);
F_tilde_fit = model(p_fit,lmda);

end

function [F_tilde] = model(p,lmda)

import org.opensim.modeling.*
tendonFL = TendonForceLengthCurve(p(1), p(2), p(3), p(4));

F_tilde = zeros(size(lmda));
for i = 1:length(lmda)
    F_tilde(i) = tendonFL.calcValue(lmda(i)); 
end

end

function [c,ceq] = mycon(p)

c = 1 - p(1)*p(2); 
ceq = [];

end

function [err] = myfun(p,model,xdata,ydata)

yfit = model(p,xdata);

err = sum((ydata-yfit).^2);

end
