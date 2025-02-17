function [result,RAANs,Total_TOF,Total_dV,fuelconsump] = PMDTAppPlot(app, x, debrisID, param)

% Same as PMDT, but for the app so that the plots are done on the app
fconsg = 0;TOFg = 0;

m_debris = zeros(size(debrisID));
debris = zeros(length(debrisID),6);

RAANs = [];
for i = 1:length(debrisID)
    [~, ~, debris(i,:), m_debris(i)] = getPosition(param.t0, ...
        debrisID(i),param.mu);
    RAANs(i) = debris(i,4); 
end

%% Leg 1 : From debris orbit 1 to 350 km orbit.

param.legno = 1; 
param.TOFbefore = 0;
param.m0  = param.m_wet_servicer + m_debris(1);

% from debris orbit 
a0 = debris(1,1);inc0 = debris(1,3);RAAN0 = debris(1,4); 

% to deorbit orbit
af = param.target_altitude + param.Re; incf = inc0;

[TOF,Tdv, lastOmega,semiMajor, inclination, RAAN,tSeg,~,betaedel,fs,mass]=...
    ExtendedEdelbaum(a0,  af, inc0,incf,RAAN0,param);

Total_TOF = TOF/param.TU; Total_dV = Tdv(end); 

mass_after = param.m0/exp(Tdv(end)/param.Isp/param.g0); 
mf(1) = param.m0  - mass_after;



 if param.plots == true
     
     % write to text file.
     fileID = fopen('Trajdata.txt', 'a');
     fprintf(fileID, '%6s \n', 'Leg 1');
     fprintf(fileID, '%6s %6s %6s %6s \n', 'time(d)', 'sma(km)', 'inc (rad)', 'RAAN (rad)');
     
     for i=1:length(semiMajor)
         fprintf(fileID, '%f %f %f %f \n',tSeg(i)/param.TU, semiMajor(i), inclination(i), RAAN(i));
     end
     
     datevec = datetime(param.t0, 'ConvertFrom','juliandate', 'Format','dd-MM-yyy');
     
     fprintf('Launch date : %s \n',  datestr(datevec));
     fprintf('Isp :  %.2f s  \n', param.Isp);
     fprintf('Maximum thrust : %.2f N \n', param.T);
     
     if param.Topt == true
         fprintf('TIME OPTIMAL TRAJECTORY \n');
     else
         
         fprintf('FUEL OPTIMAL TRAJECTORY \n');
     end
     
     
     if param.eclipses == true
         fprintf('Trajectory accounts for eclipses \n');
         fprintf('Duty Ratio : %.2f  \n', param.dutyRatio);
     end
     
     if param.drag == true
         fprintf('Trajectory accounts for drag \n');
     end
     
     
     fprintf('Target altitude = %.2f km \n', param.target_altitude/1e3);
     fprintf('..............................\n')
     
     fprintf('Leg 1: From Debris 1 to orbit below ISS \n')
     fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', ...
         a0/1e3, inc0*180/pi,RAAN0*180/pi);
     fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', ...
         af/1e3, incf*180/pi,lastOmega*180/pi);
     fprintf('Delta v = %f m/s \n', Total_dV);
     fprintf('TOF = %f days \n', Total_TOF);
     
     cla(app.UIAxes1, 'reset'); % Clear existing axes

     t = tiledlayout(app.Leg1Tab, 3, 1, 'TileSpacing', 'compact');

     ax1 = nexttile(t);
     hold(ax1,'on');
     plot(ax1,tSeg/param.TU, a0/1e3*ones(size(tSeg)), 'r--');
     plot(ax1,tSeg/param.TU, af/1e3*ones(size(tSeg)),'g--');
     p = plot(ax1,tSeg/param.TU,semiMajor/1e3,'c');
     xlim([min(param.TOFbefore+tSeg/param.TU),max(param.TOFbefore+tSeg/param.TU)]);
     ax1.XLabel.String = 'time(days)';
     ax1.YLabel.String = 'a (km)';
     % ax1.Legend = {'Initial', 'Target', 'PMDT'}; 

     ax2 = nexttile(t);
     hold(ax2,'on');
     plot(ax2,tSeg/param.TU, rad2deg(inc0*ones(size(tSeg))), 'r--');
     plot(ax2,tSeg/param.TU, rad2deg(incf*ones(size(tSeg))),'g--');
     p = plot(ax2,tSeg/param.TU,inclination*180/pi, 'c');
     ax2.YLim=([inc0*180/pi-1, inc0*180/pi+1]);
     ax2.XLim=([min(param.TOFbefore+tSeg/param.TU),max(param.TOFbefore+tSeg/param.TU)]);
     ax2.XLabel.String = 'time(days)';
      ax2.YLabel.String = 'inclination (deg)';
     % plot_latex(p, 'time(days)', 'inc (deg)','', '' ,{});
     
      ax3 = nexttile(t);
        hold(ax3,'on');
     Omega_x0 = RAAN0 -param.k*(param.mu/a0)^3.5*cos(inc0)*tSeg;
     plot(ax3,tSeg/param.TU, rad2deg(Omega_x0), 'r--');
     p = plot(ax3,tSeg/param.TU,RAAN*180/pi, 'c');
     xlim([min(param.TOFbefore+tSeg/param.TU),max(param.TOFbefore+tSeg/param.TU)]);
     ax3.XLabel.String = 'time(days)';
     ax3.YLabel.String = 'RAAN (deg)';
   
 end

wt = zeros(1,length(debrisID)-1);

k = 1;
for j = 1: length(debrisID)-1
  
    %% Proximity operations to handover the debris to the sheperd.
 
   
    param.TOFbefore = Total_TOF;
    param.dVbefore = Total_dV;
    
    if param.plots == true
        
        tlo = linspace(0.001,param.RDV2,20);
        RAAN_h = lastOmega -param.k*(param.mu/af)^3.5*cos(incf)*tlo;
        fprintf(fileID, '%6s \n', 'Proxop');
        for i=1:length(RAAN_h)
            fprintf(fileID, '%f %f %f %f \n',param.TOFbefore+ tlo(i)/param.TU,...
              af, incf, RAAN_h(i));
        end
        
    end

    Omega_0_new = lastOmega -param.k*(param.mu/af)^3.5*cos(incf)*param.RDV2;
    
    Total_TOF = Total_TOF + param.RDV2/param.TU;
   
    if param.plots == true
        
        fprintf('..............................\n')
        fprintf('Proximity operations to handover the debris %d to the sheperd. \n', i-1)
        fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
            lastOmega*180/pi);
        fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
            Omega_0_new*180/pi);
        fprintf('TOF = %f days \n', param.RDV2/param.TU);
  
    end
    
    %% Leg 2/4 : From deorbit orbit to debris orbit.
    
%     


    param.legno =  param.legno + 1; 
    param.TOFbefore = Total_TOF;
    param.dVbefore = Total_dV;
    
    param.m0 = mass_after -  m_debris(j);
    
    % from deorbit orbit
    a0 = param.target_altitude + param.Re; inc0 = incf; RAAN0 = Omega_0_new;
    
    % to debris orbit 2
    af =  debris(j+1,1);
    incf = debris(j+1,3);
    RAANf_t0 = debris(j+1,4)-param.k*(param.mu/af)^3.5*cos(incf)*Total_TOF*param.TU;

    
   %param.guidance = true;
    [Tdv,TOF,Omega2,wt(k), ~, fg, tofg] = processUpLegApp(app, x(j+k-1:j+k), a0,inc0,RAAN0 , af, incf,...
        RAANf_t0, param);
    k = k +1;
    %param.guidance = false;


    Total_TOF = Total_TOF +TOF/param.TU;
    Total_dV = Total_dV + Tdv(end); 
    mass_after = param.m0 /exp(Tdv(end)/param.Isp/param.g0);
    mf = [mf, param.m0- mass_after];
    
    if param.plots == true
        fprintf('..............................\n')
        fprintf('From the orbit below ISS to Debris %d \n', i);
        fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', a0/1e3, inc0*180/pi,...
            RAAN0*180/pi);
        fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
            Omega2*180/pi);
        fprintf('Delta v = %f km/s \n', Tdv(end));
        fprintf('TOF = %f days \n', TOF/param.TU);
        
    end

    %% Proximity operations at the target
    
    param.TOFbefore = Total_TOF;
    param.dVbefore = Total_dV;

     if param.plots == true
         tlo = linspace(0.001,param.RDV1,20);
         RAAN_h = Omega2 -param.k*(param.mu/af)^3.5*cos(incf)*tlo;
         fprintf(fileID, '%6s \n', 'Proxop');
         for i=1:length(RAAN_h)
             fprintf(fileID, '%f %f %f %f \n',param.TOFbefore+ tlo(i)/param.TU,...
                 af, incf, RAAN_h(i));
         end
         
     end

    RAAN2 = Omega2 -param.k*(param.mu/af)^3.5*cos(incf)*param.RDV1;
    Total_TOF = Total_TOF +param.RDV1/param.TU;
    
    if param.plots == true
        
        fprintf('..............................\n')
        fprintf(' Proximity operations at the Debris %d \n', i)
        fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
            Omega2*180/pi);
        fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
            RAAN2*180/pi);
        fprintf('TOF = %f days \n', param.RDV1/param.TU);
        
    end
            
%param.guidance = false;
 
    
    %% Leg 3/5
    

%     
%param.guidance = false;


    param.legno =  param.legno + 1; 
    
    param.TOFbefore = Total_TOF;
    param.dVbefore = Total_dV;
    
    param.m0 = mass_after +  m_debris(j+1);
    % from debris orbit 2
    a0 = debris(j+1,1); inc0 = debris(j+1,3); RAAN0 = RAAN2;
    
    % to deorbit orbit
    af = param.target_altitude + param.Re; incf = inc0;
    
    [TOF,Tdv,lastOmega,semiMajor, inclination, RAAN,tSeg,~,betaedel,fs] =...
        ExtendedEdelbaum(a0,  af, inc0,incf,RAAN0,param);

    Total_TOF = Total_TOF +TOF/param.TU;
    Total_dV = Total_dV + Tdv(end); 
  
    mass_after = param.m0/exp(Tdv(end)/param.Isp/param.g0);
    mf = [mf, param.m0- mass_after];


    
 
   
    if param.plots == true
        
        fprintf(fileID, '%6s \n', strcat('Leg' ,num2str(param.legno)));
        fprintf(fileID, '%6s %6s %6s %6s \n', 'time(d)', 'sma(km)', 'inc (rad)', 'RAAN (rad)');
        
        for i=1:length(semiMajor)
            fprintf(fileID, '%f %f %f %f \n', param.TOFbefore+tSeg(i)/param.TU, semiMajor(i), inclination(i), RAAN(i));
        end
       
        fprintf('..............................\n')
        fprintf('From debris %d to orbit below ISS \n', i);
        fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', a0/1e3, inc0*180/pi,...
            RAAN0*180/pi);
        fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
            lastOmega*180/pi);
        
        fprintf('Delta v = %f m/s \n', Tdv(end));
        fprintf('TOF = %f days \n', TOF/param.TU);
        

        cla(strcat('app.UIAxes', num2str(param.legno)), 'reset'); % Clear existing axes

        tabHandle = app.(['Leg', num2str(param.legno), 'Tab']);

        % Create the tiled layout inside the selected tab
        t = tiledlayout(tabHandle, 3, 1, 'TileSpacing', 'compact');

   
        ax1 = nexttile(t);
        hold(ax1,'on');
        plot(ax1,param.TOFbefore+tSeg/param.TU, a0/1e3*ones(size(tSeg)), 'r--');
        plot(ax1,param.TOFbefore+tSeg/param.TU, af/1e3*ones(size(tSeg)),'g--');
        p = plot(ax1,param.TOFbefore+tSeg/param.TU,semiMajor/1e3, 'c');
  
        ax1.XLim = ([min(param.TOFbefore+tSeg/param.TU),max(param.TOFbefore+tSeg/param.TU)]);
        
         ax1.XLabel.String = 'time(days)';
         ax1.YLabel.String = 'a (km)';
    
        ax2 = nexttile(t);
        hold(ax2,'on');
        plot(ax2,param.TOFbefore+tSeg/param.TU, rad2deg(inc0*ones(size(tSeg))), 'r--');
        plot(ax2,param.TOFbefore+tSeg/param.TU, rad2deg(incf*ones(size(tSeg))),'g--');
        p = plot(ax2,param.TOFbefore+tSeg/param.TU,inclination*180/pi, 'c');

        ax2.YLim = ([inc0*180/pi-1, inc0*180/pi+1]);
        ax2.XLim  = ([min(param.TOFbefore+tSeg/param.TU),max(param.TOFbefore+tSeg/param.TU)]);
        ax2.XLabel.String = 'time (days)';
        ax2.YLabel.String = 'inclination (deg)';

      
        ax3 = nexttile(t);
        hold(ax3,'on');
        Omega_x0 = RAAN0 -param.k*(param.mu/a0)^3.5*cos(inc0)*tSeg;
        plot(ax3,param.TOFbefore+tSeg/param.TU, wrapTo360(rad2deg(Omega_x0)), 'r--');
        p = plot(ax3,param.TOFbefore+tSeg/param.TU,wrapTo360(RAAN*180/pi), 'c');

        ax3.XLim = ([min(param.TOFbefore+tSeg/param.TU),max(param.TOFbefore+tSeg/param.TU)]);
         ax3.XLabel.String = 'time (days)';
        ax3.YLabel.String = 'RAAN (deg)';

    end
    

   

end

param.TOFbefore = Total_TOF;
param.dVbefore = Total_dV;
% Proximity operations to handover the debris to the sheperd.
Total_TOF = Total_TOF +param.RDV2/param.TU;
Omega_0_new = lastOmega -param.k*(param.mu/af)^3.5*cos(incf)*param.RDV2;

if param.plots == true
    tlo = linspace(0.001,param.RDV2,20);
    RAAN_h = lastOmega -param.k*(param.mu/af)^3.5*cos(incf)*tlo;
    fprintf(fileID, '%6s \n', 'Proxop');
    for i=1:length(RAAN_h)
        fprintf(fileID, '%f %f %f %f \n',param.TOFbefore+ tlo(i)/param.TU,...
            af, incf, RAAN_h(i));
    end
    
end

if param.plots == true
     fclose(fileID);
     
    fprintf('..............................\n')
    fprintf('Proximity operations to handover the debris %d to the sheperd. \n', i)
    fprintf('From a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
        lastOmega*180/pi);
    fprintf('To a = %.2f km, i = %.2f deg and RAAN = %.2f deg \n', af/1e3, incf*180/pi,...
        Omega_0_new*180/pi);
    fprintf('TOF = %f days \n', param.RDV2/param.TU);
    
    fprintf('-------------------------------------- \n')
    fprintf('Total Delta v = %f m/s \n',Total_dV);
    fprintf('Total TOF = %f days \n', Total_TOF);
    fprintf('Total fuel consumed = %f kg \n', sum(mf));
end

fuelconsump = sum(mf);

if param.Topt == true
    result = Total_TOF;
else
    result = Total_dV;
end





