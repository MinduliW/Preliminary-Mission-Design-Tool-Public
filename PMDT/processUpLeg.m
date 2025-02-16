function [Total_dv1,TOF1,targetRAAN,waittime,rrs,fg, tofg] = processUpLeg...
    (x , a0,inc0,RAAN0 , af, incf, RAANf,param)
rrs = 0;

% Initital orbit at the start of leg 2
v0  =  sqrt(param.mu/a0);
param.x0 = [v0 , inc0,RAAN0];

% Target orbit at the start of leg 2
vf  = sqrt(param.mu/af);
param.xf = [vf , incf, RAANf];

ks = param.krange;
waittimes = zeros(size(ks));
for i = 1: length(ks)
    % calculate waittime in days
    waittimes(i) = getDriftTime(x,ks(i), param);
end

%waittimes
% positive waittimes
waitT = waittimes(waittimes > 0);
ks = ks(waittimes > 0);

[waittime, index] = min(waitT);

if isempty(waitT)
    waittime = 10e10;
    ks  = param.krange;
    index = length(param.krange);
end

k = ks(index);




x(3) =  waittime;


[Total_dv1,TOF1,Omegadiff ,leg1,leg2,waitTimevec, targetRAAN,wait]   = ...
    resultsForSingleLeg(x,k , param);

if param.plots == true
        fprintf("drift dv %f m/s , fuel %f kg \n" ,wait.dv ,wait.fcons);
    
end



fg = 0;
tofg = 0;


%waitTimevec = linspace(leg1.t(end), leg1.t(end)+waittime, 100);

if param.plots == true
    
    datevec = datetime(param.t0+param.TOFbefore, 'ConvertFrom','juliandate', 'Format','dd-MM-yyy');
   
    fprintf('..............................\n')
    fprintf('To drift orbit\n');
    fprintf('Start date : %s \n',  datestr(datevec));
    fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', a0/1e3, inc0*180/pi,...
        RAAN0*180/pi);
    fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', leg1.a(end)/1e3,...
        leg1.inc(end)*180/pi,...
        leg1.RAAN(end)*180/pi);
    fprintf('TOF = %f days \n', leg1.t(end)/param.TU);
    fprintf('dv = %f km/s \n', leg1.dV(end));
    mass_after = param.m0 /exp(leg1.dV(end)/param.Isp/param.g0);
    f1 = param.m0- mass_after;
   
    fprintf('Fuel used = %f kg \n', f1);
     
    
    param.m0 = mass_after;
     
    fprintf('..............................\n')
     datevec = datetime(param.t0+param.TOFbefore+leg1.t(end)/param.TU, 'ConvertFrom','juliandate', 'Format','dd-MM-yyy');

    fprintf('Drifting \n')
     fprintf('Start date : %s \n',  datestr(datevec));
    fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', leg1.a(end)/1e3,...
        leg1.inc(end)*180/pi,...
        leg1.RAAN(end)*180/pi);
    fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', leg2.a(1)/1e3, leg2.inc(1)*180/pi,...
        leg2.RAAN(1)*180/pi);
    fprintf('TOF = %f days \n', waittime/param.TU);
   
    fprintf('Fuel used = %f kg \n', wait.fcons);

    fprintf('..............................\n')
    datevec = datetime(param.t0+param.TOFbefore+leg1.t(end)/param.TU...
           +waittime/param.TU, 'ConvertFrom','juliandate', 'Format','dd-MM-yyy');

    fprintf('Drift to Debris  \n')
        fprintf('Start date : %s \n',  datestr(datevec));
    fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', leg2.a(1)/1e3, leg2.inc(1)*180/pi,...
        leg2.RAAN(1)*180/pi);
    fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', leg2.a(end)/1e3, leg2.inc(end)*180/pi,...
       targetRAAN*180/pi);
    fprintf('TOF = %f days \n', (leg2.t(end)-leg1.t(end)-waittime)/param.TU);
   
    fprintf('dv = %f km/s \n', leg2.dV(end));
    mass_after = param.m0 /exp(leg2.dV(end)/param.Isp/param.g0);
    f2 = param.m0- mass_after;
    fprintf('Fuel used = %f kg \n', f2);

    fprintf('..............................\n')
    fprintf('Totals  \n')
    fprintf('Fuel = %f kg \n', wait.fcons+f1+f2);
    fprintf('TOF = %f days \n', TOF1/param.TU);
    fprintf('dv = %f km/s \n', Total_dv1);
    
    param.m0 = mass_after;
    
    figure;
    subplot(3,1,1);hold on;
    wt = linspace(leg1.t(end), leg2.t(1), 500);
    tSeg = linspace(0,TOF1, 500);
    
    tT = param.TOFbefore+tSeg/param.TU; 
    tL1 = param.TOFbefore+leg1.t/param.TU;
    tw = param.TOFbefore+leg1.t(end)/param.TU +wait.timevec/param.TU;
    tL2 = param.TOFbefore+leg2.t/param.TU;
    
    
    plot(tT, a0/1e3*ones(size(tSeg)), 'r--');
    plot(tT, af/1e3*ones(size(tSeg)),'g--');
    plot(tL1,leg1.a/1e3, 'c');
    plot(tw,wait.a/1e3, 'c' )
    p = plot(tL2,leg2.a/1e3, 'c');
    

    xlim([min(param.TOFbefore +tSeg/param.TU),max(param.TOFbefore +tSeg/param.TU)]);
   
    plot_latex(p, 'time(days)', 'a (km)','', strcat('Leg' , '{ }', ...
        num2str(param.legno)) ,{'Initial','Target','Thrust phase 1',...
        'Coast phase',...
        'Thrust phase 2', 'Ruggeiro', 'Lyupunov'});
    
    subplot(3,1,2); hold on;
    plot(tT, rad2deg(param.x0(2)*ones(size(tSeg))), 'r--');
    plot(tT, rad2deg(param.xf(2)*ones(size(tSeg))),'g--');
    plot(tL1,leg1.inc*180/pi ,'c');
    plot(tw,leg1.inc(end)*180/pi*ones(size(tw)) ,'c')
    p = plot(tL2,leg2.inc*180/pi, 'c');
    %ylim([98,99])
    xlim([min(tT),max(tT)]);
   
    plot_latex(p, 'time(days)', 'inc(deg)','', '' ,{ });
    
    Omega_t2 = wrapTo2Pi(leg1.RAAN(end) -param.k*x(1)^7*cos(x(2))*(wt-leg1.t(end))); %rad
    Omega_x0 = wrapTo2Pi(param.x0(3)-param.k*v0^7*cos(inc0)*tSeg);
    Omega_xf =  wrapTo2Pi(param.xf(3) -param.k*param.xf(1)^7*cos(param.xf(2))*(tSeg) + 2*k*pi);
    Omega_tw = wrapTo2Pi(wait.Omega);
    
   subplot(3,1,3); hold on;
    plot(tT, rad2deg(Omega_x0), 'r--');
    plot(tT, rad2deg(Omega_xf),'g--')
    plot(tL1,wrapTo2Pi(leg1.RAAN)*180/pi,'c')
    plot(tw,Omega_tw*180/pi, 'c');
    p = plot(tL2,wrapTo2Pi(leg2.RAAN)*180/pi, 'c');
    ylim([0,360]);
    xlim([min(param.TOFbefore +tSeg/param.TU),max(param.TOFbefore +tSeg/param.TU)]);
   
    
    
    plot_latex(p, 'time(days)', '$\Omega$ (deg)','', '' ,{});
    
    fileID = fopen('Trajdata.txt', 'a');
    fprintf(fileID, '%6s \n', strcat('Leg' ,num2str(param.legno)));
    fprintf(fileID, '%6s %6s %6s %6s \n', 'time(d)', 'sma(km)', 'inc (rad)', 'RAAN (rad)');
    fprintf(fileID, '%6s \n', 'thrust 1');
    for i=1:length(tL1)
        fprintf(fileID, '%f %f %f %f \n', tL1(i), leg1.a(i), leg1.inc(i), leg1.RAAN(i));
    end
    fprintf(fileID, '%6s \n', 'drifting');
    for i=1:length(tw)
        fprintf(fileID, '%f %f %f %f \n',tw(i), wait.a(i), leg1.inc(end), Omega_tw(i));
    end
    
    fprintf(fileID, '%6s \n', 'thrust 2');
    for i=1:length(tL2)
        fprintf(fileID, '%f %f %f %f \n',tL2(i), leg2.a(i), leg2.inc(i), leg2.RAAN(i));
    end
    
    
end

end