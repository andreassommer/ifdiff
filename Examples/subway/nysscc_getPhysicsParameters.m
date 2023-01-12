function p = nysscc_getPhysicsParameters(varargin)
% returns a structure with parameters

% for speed up, use persistent variables
persistent pp
 
if (nargin>0)
   p = [];
   disp('Parameters reset.')
   return
end

if ~isempty(pp)
   p = pp;
   return
end

% Werte aus Sager2009
% ===================
% pp.Tmax  = 65;        % Maximal driving time (seconds)
% pp.S     = 2112;      % driving distance (feet) = 643,7376m
% pp.S4    = 700;      
% pp.W     = 78000;           % weight of the train (lbs) = 35380,205 kg
% pp.Weff  = pp.W + 72000*0.1; % effective weight of the train (lbs)
% pp.gamma = 3600/5280;       % scaling factor s/h / ft/mile
% pp.a     = 100;       % front surface of train (foot^2)
% pp.nwag  = 10;        % number of wagons
% pp.b     = 0.045;
% pp.c     = 0.24 + 0.034*(pp.nwag-1)/(100*pp.nwag);
% pp.C     = 0.367;         % constant braking when coasting
% pp.g     = 32.2;          % gravity (ft/s^2)
% pp.e     = 1.0;           % percentage of working machines
% pp.v1 = 0.979474;     % velocity limits
% pp.v2 = 6.73211;      % velocity limits
% pp.v3 = 14.2658;      % velocity limits
% pp.v4 = 22.0;         % point constraint (mph)
% pp.v5 = 24.0;         % path constraing (mph)
% pp.a1 = 6017.611205;  % acceleration
% pp.a2 = 12348.34865;  % acceleration
% pp.a3 = 11124.63729;  % acceleration
% pp.umax = 4.4;        % maximal deceleration
%pp.p1 = 106.1951102;   % energy consumption
%pp.p2 = 180.9758408;   % energy consumption
%pp.p3 = 354.136479;    % energy consumption


% Werte aus subway.cpp
% ====================
pp.Tmax  = 65;                % maximal driving time (seconds)
pp.S     = 2112;              % driving distance (feet) = 643,7376m
pp.W     = 78000;             % weight of the train (lbs) = 35380,205 kg
pp.Weff  = pp.W + 72000*0.1;  % effective weight of the train (lbs)
pp.gamma = 3600/5280;         % scaling factor s/h / ft/mile
pp.a     = 100;               % front surface of train (foot^2)
pp.nwag  = 10;                % number of wagons
pp.b     = 0.045;
pp.c     = ( 0.24 + 0.034*(pp.nwag-1) ) / (100*pp.nwag); 
pp.C     = 0.367 * pp.gamma;  % constant braking when coasting
pp.g     = 32.2 * pp.gamma;   % gravity (ft/s^2)
pp.e     = 1.0;               % percentage of working machines
pp.umax  = -3.0 / pp.gamma;   % maximal deceleration: approx 4.4
pp.v1 = ( 1.03 - (pp.W - 72000) / ( 110000 - 72000) * ( 1.03 -  0.71) ) / pp.gamma;    % 
pp.v2 = ( 6.86 - (pp.W - 72000) / ( 110000 - 72000) * ( 6.86 -  6.05) ) / pp.gamma;    % velocity limits
pp.v3 = (14.49 - (pp.W - 72000) / ( 110000 - 72000) * (14.49 - 13.07) ) / pp.gamma;    %
pp.a1 = ( 5998.6162 + (pp.W - 72000) / ( 110000 - 72000) * ( 6118.9179 -  5998.6162) );   %
pp.a2 = (11440.7968 + (pp.W - 72000) / ( 110000 - 72000) * (17188.6252 - 11440.7968) );   % acceleration
pp.a3 = (10280.0514 + (pp.W - 72000) / ( 110000 - 72000) * (15629.0954 - 10280.0514) );   %
pp.p1 = (105.880645 + (pp.W - 72000) / ( 110000 - 72000) * (107.872258 - 105.880645) ); %
pp.p2 = (168.931957 + (pp.W - 72000) / ( 110000 - 72000) * (245.209888 - 168.931957) ); % energy consumption
pp.p3 = (334.626716 + (pp.W - 72000) / ( 110000 - 72000) * (458.188550 - 334.626716) ); %

% coefficients bi(w(t)) and ci(w(t))
pp.B01  = -0.1983670410E02;
pp.B11  =  0.1952738055E03;
pp.B21  =  0.2061789974E04;
pp.B31  = -0.7684409308E03;
pp.B41  =  0.2677869201E03;
pp.B51  = -0.3159629687E02;
pp.B02  = -0.1577169936E03;
pp.B12  =  0.3389010339E04;
pp.B22  =  0.6202054610E04;
pp.B32  = -0.4608734450E04;
pp.B42  =  0.2207757061E04;
pp.B52  = -0.3673344160E03;
pp.C01  =  0.3629738340E02;
pp.C11  = -0.2115281047E03;
pp.C21  =  0.7488955419E03;
pp.C31  = -0.9511076467E03;
pp.C41  =  0.5710015123E03;
pp.C51  = -0.1221306465E03;
pp.C02  =  0.4120568887E02;
pp.C12  =  0.3408049202E03;
pp.C22  = -0.1436283271E03;
pp.C32  =  0.8108316584E02;
pp.C42  = -0.5689703073E01;
pp.C52  = -0.2191905731E01;


p = pp;
end