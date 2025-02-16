function [c,ceq] = PMDT_limits(x, debrisID, param)

[~,~,Total_TOF,Total_dV] = PMDT(x, debrisID, param);

if param.Topt == true
   
    c = Total_dV - param.dvLimit*1e3;
else
   c = Total_TOF- param.waitTimeLimit;
end


ceq = [];