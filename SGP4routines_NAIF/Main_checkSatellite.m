% clear;
% clc;

constants;

if ismac
    addpath('/Users/minduli/libraries_mice/mice/src/mice/')
    addpath('/Users/minduli/libraries_mice/mice/lib')
    addpath('../Paper test cases')
    kernelfile = 'kernelmac.txt';

else

    addpath('C:\Users\mwij516\mice\mice\src\mice')
    addpath('C:\Users\mwij516\mice\mice\lib')
    addpath('C:\Users\mwij516\Astroscale_ADR\Astroscale_ADR-master\Main\Paper test cases')
    kernelfile = 'kernel.txt';

end
cspice_furnsh(kernelfile)

active = true; 


if active == true
    Norad ='33492';
else
    Norad = '33500'; 
end
SatID = num2str(-100000-str2double(Norad));


% element


%%
%To print to screen the window of validity of kernels (example on Norad1):
SPK1 = strcat('kernels/SPK',Norad,'.bsp');
MAXIV  = 1;
WINSIZ = 2 * MAXIV;
ids = cspice_spkobj( SPK1, MAXIV );
cover = cspice_spkcov( SPK1, ids(1), WINSIZ );

initepoch = cspice_et2utc(cover(1),'C',2);
finepoch = cspice_et2utc(cover(2),'C',2);
fprintf('Initial epoch: %s \n', initepoch);
fprintf('Final epoch: %s  \n', finepoch);

% timevec
timevec = cover(1)+1:100:cover(1)+15000; 

RAANs = zeros(size(timevec));
RAAN_cur = zeros(size(timevec));
for i = 1: length(timevec)
     cspice_furnsh(kernelfile)
     timstr = cspice_et2utc(timevec(i),'C',2);

    newstr = timstr; %strcat('JD', {' '}, num2str(timevec(i)));

    et = cspice_str2et(newstr);

    State1 = cspice_spkezr(SatID, et, 'J2000', 'LT+S', '399');

    Stateprop = spice_sgp4(et,active);

    statefromTLE(i,:)  = State1';
    statefromSGP4(i,:) = Stateprop';

end

figure;
subplot(1,2,1); hold on; 
plot3(statefromTLE(:,1), statefromTLE(:,2), statefromTLE(:,3),'r-')
p = plot3(statefromSGP4(:,1), statefromSGP4(:,2), statefromSGP4(:,3),'b--')
plot_latex(p, 'x(km)', 'y(km)','z(km)', Norad ,{'from TLEs' , 'SGP4'})

subplot(1,2,2);hold on; 
p = plot((timevec-timevec(1))*24, statefromTLE(:,1)-statefromSGP4(:,1));

plot((timevec-timevec(1))*24, statefromTLE(:,2)-statefromSGP4(:,2));
p = plot((timevec-timevec(1))*24, statefromTLE(:,3)-statefromSGP4(:,3));
plot_latex(p, 'time(h)', 'position(km)','', Norad ,{'x', 'y', 'z'})


