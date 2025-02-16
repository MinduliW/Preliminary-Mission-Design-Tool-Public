function [x0, ub,lb] = getInitGuess(param)
 
% Any date works here, it's just to get a and inc.
%param.t0 = juliandate(2022,03,25, 6,37,13); 



debris = zeros(length(param.debrisID),6);

for i = 1:length(param.debrisID)
    [~, ~, debris(i,:)] = getPosition(param.t0 ,param.debrisID(i),param.mu);
end


x0 = [];
lb = [];
ub = []; 

% a_driftmax = param.target_altitude+ param.Re +100e3;
% v_dmax = sqrt(param.mu/a_driftmax);

a_RL = param.Re+300e3;
v_RL = sqrt(param.mu/a_RL);


for j = 2: length(param.debrisID)
    a0 = param.target_altitude + param.Re; inc0 = debris(j-1,3);
    v0 = sqrt(param.mu/a0);
    
   af =  debris(j,1);incf = debris(j,3);
   vf = sqrt(param.mu/af);
   

x0 = [x0,  min([v0,vf]), min([inc0,incf])+0.001];
lb = [lb , 0, 0];
ub = [ub, v_RL, pi];
end


