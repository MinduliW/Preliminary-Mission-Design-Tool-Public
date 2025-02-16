function eta = isEclipse(time, semiMajor, eccentricity, inclination, RAAN, AOP, theta, param)

tdaysJD = time/86400 + param.t0+ param.TOFbefore;
kepElements = [semiMajor, eccentricity, inclination, RAAN, AOP,theta];
rr = CoordConv.po2pv(kepElements, param.mu); %m, m/s
r_Earth2Sun = getSunPosVec(tdaysJD , param);

eta = eclipse(-r_Earth2Sun+rr, rr(1:3), param);

