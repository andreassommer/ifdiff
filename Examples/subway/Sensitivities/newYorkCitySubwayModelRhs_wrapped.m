function dy = newYorkCitySubwayModelRhs_wrapped(t, y, p)

pp.Tmax  = p(1);
pp.S     = p(2);
pp.W     = p(3);
pp.Weff  = p(4);
pp.gamma = p(5);
pp.a     = p(6);
pp.nwag  = p(7);
pp.b     = p(8);
pp.c     = p(9);
pp.C     = p(10);
pp.g     = p(11);
pp.e     = p(12);
pp.umax  = p(13);
pp.v1    = p(14);
pp.v2    = p(15);
pp.v3    = p(16);
pp.a1    = p(17);
pp.a2    = p(18);
pp.a3    = p(19);
pp.p1    = p(20);
pp.p2    = p(21);
pp.p3    = p(22);
pp.B01   = p(23);
pp.B11   = p(24);
pp.B21   = p(25);
pp.B31   = p(26);
pp.B41   = p(27);
pp.B51   = p(28);
pp.B02   = p(29);
pp.B12   = p(30);
pp.B22   = p(31);
pp.B32   = p(32);
pp.B42   = p(33);
pp.B52   = p(34);
pp.C01   = p(35);
pp.C11   = p(36);
pp.C21   = p(37);
pp.C31   = p(38);
pp.C41   = p(39);
pp.C51   = p(40);
pp.C02   = p(41);
pp.C12   = p(42);
pp.C22   = p(43);
pp.C32   = p(44);
pp.C42   = p(45);
pp.C52   = p(46);


v = y(2);

if t < 3.64338
   if v <  pp.v1
      dyTemp = [  y(2) ; ...                                       % position
                  pp.g * pp.e * pp.a1 / pp.Weff / pp.gamma ; ...   % velocity
                  pp.p1 ];                                         % energy;
   else
      if v <  pp.v2
         dyTemp = [  y(2) ; ...                                     % position
                     pp.g * pp.e * pp.a2 / pp.Weff / pp.gamma ; ... % velocity
                     pp.p2 ];                                       % energy
      else
         dyTemp = [  y(2) ; ...                                                              % position
                     pp.g * ( pp.e * fun_T1(y(2)) - fun_R(y(2)) ) / pp.Weff / pp.gamma ; ... % velocity
                     pp.e * fun_L1(y(2))];                                                   % energy
      end
      
   end
else
   if t < (8.96367 + 3.64338)
      if v <  pp.v2
         dyTemp = [  y(2); 0; 0 ];    % position; velocity; energy;
      else
         if v <  pp.v3
            dyTemp = [  y(2); ...                                     % position
                        pp.g * pp.e * pp.a3 / pp.Weff / pp.gamma; ... % velocity
                        pp.p3];                                       % energy;
         else
            dyTemp = [  y(2); ...                                                             % position
                        pp.g * ( pp.e * fun_T2(y(2)) - fun_R(y(2)) ) / pp.Weff / pp.gamma;... % velocity
                        pp.e * fun_L2(y(2))];                                                 % energy;
         end
      end
   else
      if t < (3.64338 + 8.96367 + 33.1757)
         if v <  pp.v1
            dyTemp = [  y(2) ; ...                                       % position
                        pp.g * pp.e * pp.a1 / pp.Weff / pp.gamma ; ...   % velocity
                        pp.p1 ];                                         % energy;
         else
            if v <  pp.v2
               dyTemp = [  y(2) ; ...                                     % position
                           pp.g * pp.e * pp.a2 / pp.Weff / pp.gamma ; ... % velocity
                           pp.p2 ];                                       % energy
            else
               dyTemp = [  y(2) ; ...                                                              % position
                           pp.g * ( pp.e * fun_T1(y(2)) - fun_R(y(2)) ) / pp.Weff / pp.gamma ; ... % velocity
                           pp.e * fun_L1(y(2))];                                                   % energy
            end
            
         end
      else
         if t < (3.64338 + 8.96367 + 33.1757 + 11.3773)
            if v <= 0
               dyTemp = [0; 0; 0];
            else
               dyTemp = [  y(2);...                                             % position
                           - pp.g * fun_R(y(2)) / pp.Weff - pp.C / pp.gamma;... % velocity
                           0];                                                  % energy
            end
         else
            if v <= 0
               dyTemp = [0; 0; 0];
            else
               dyTemp = [  y(2); ...    % position
                           pp.umax; ... % velocity     % note:  param.umax=-3.0  gamma=-4.4
                           0];          % energy
            end
         end
      end
   end
end

dy = dyTemp;

end