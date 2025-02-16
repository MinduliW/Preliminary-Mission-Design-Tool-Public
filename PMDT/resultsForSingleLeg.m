function [Tot_dv,TOF,Omegadiff ,leg1,leg2,waitTimevec, targetRAAN,wait,fuelburnt] ...
    = resultsForSingleLeg(x,k, param)


% resultsForSingleLeg: compiles the results of a single leg of the tour,
% and can also plot the sma, inc and RAAN changes in that leg if asked. 


Vd = x(1); %m/s
Id = x(2); % rad
waitTime = x(3);  %s

startmass = param.m0; 
a0 = param.mu/param.x0(1)^2; %m
ad = param.mu/Vd^2; %m
af = param.mu/param.xf(1)^2; %m

%% Leg 1 
param.timeprev = 0; 
[leg1.t1,leg1.dV, Omega_t1, leg1.a , leg1.inc, leg1.RAAN,leg1.t, ~,leg1.beta,...
    leg1.fs,leg1.mass] = ExtendedEdelbaum(a0, ad, param.x0(2),Id,param.x0(3),param);

%% Waiting 

wait.timevec = linspace(0, waitTime,100);
wait.a = leg1.a(end)*ones(size(wait.timevec));
wait.Omega =  Omega_t1 -param.k*Vd^7*cos(Id)*(wait.timevec);


[~, ~, dv_dragCorrection, masscons] =...
    waitDragEffect(Omega_t1, ad, Id,waitTime,leg1.mass(end), param);

waitTimevec = leg1.t1(end) + wait.timevec; 
wait.dv = dv_dragCorrection;
wait.fcons = masscons;

%% Leg 2 
param.m0 = leg1.mass(end)-masscons;
param.timeprev = leg1.t1 + waitTime; 
[leg2.t2,leg2.dV, Omega_tf,leg2.a, leg2.inc, leg2.RAAN,duration, ~, leg2.beta,leg2.fs,leg2.mass] =...
    ExtendedEdelbaum(wait.a(end),af, Id,param.xf(2) ,wait.Omega(end),param);

leg2.t = duration+ waitTimevec(end); 


%% Totals 
TOF = leg1.t1 + leg2.t2+waitTime; 
Tot_dv = leg1.dV(end) + leg2.dV(end)+dv_dragCorrection; 
targetRAAN = param.xf(3) -param.k*param.xf(1)^7*cos(param.xf(2))*(TOF)+ 2*k*pi;

Omegadiff = Omega_tf -targetRAAN;

fuelburnt =  startmass - leg2.mass(end);
end