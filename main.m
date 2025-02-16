clear, clc;  close all;
addpath('SGP4routines_NAIF');
addpath('CoordinateConversions/')
addpath('Pertubations/')
addpath('Data/')
addpath('PMDT/')
addpath('/Users/minduli/mice/src/mice/')
addpath('/Users/minduli/mice/lib')
cspice_furnsh('SGP4routines_NAIF/kernel.txt')


tic
constants;

%% Inputs
 
% Problem parameters
param.a_pchangeLimit = 0.01; %0.001;
debrisID = {'H2AF15', 'ALOS2', 'GOSAT'}; %Debris sequence

allPermutations = perms(debrisID);
[nperms, ~] = size(allPermutations);

% Servicer parameters
param.m_wet_servicer = 800;
param.dutyRatio = 0.5; 
param.T = 60e-3;
param.Isp =  1300; %s
param.Cd = 2.2;
param.Area= 5;

% Trajectory parameters
param.target_altitude = 350e3;
param.RDV1 = 1.5*30*param.TU; % Approaching the target.
param.RDV2 = 1*30*param.TU; % handing over the target at 350 km
param.waitTimeLimit =1825; %days
param.dvLimit = 1.5;
param.krange = -20:1:20;
param.dragfactor = 1; %0.1;
param.t0 = juliandate(datetime(2022,03,25, 6,37,13)); %+ 1000;

param.Topt = false;  %time optimal or fuel optimal?
param.plots = false;
param.eclipses = false;
param.drag = false ;
%% Solution

param.debrisID = allPermutations(6,:);

% generate initial guess and boundaries
[~, ub,lb] = getInitGuess(param);

x0 = [7668.55873489256,1.73887318895310,7459.17412371716,1.70295207272273];


options = optimoptions('fmincon','Display','iter');
[debrisData,fval] = fmincon(@(x) PMDT(x,debrisID,param),x0,[],[],[],[],...
    lb,ub,@(x) PMDT_limits(x, debrisID, param),options);

param.eclipses = true;
param.drag = true ; 
param.plots = true;

%% 
delete 'Trajdata.txt';

[result,RAANs,Total_TOF,Total_dV,fuelconsump] = PMDT(debrisData, debrisID, param);
