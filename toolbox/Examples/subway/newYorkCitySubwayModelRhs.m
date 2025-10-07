% newYorkCitySubwayRhs02.m -> version two
% right-hand side function of the new york city subway model

function dy = newYorkCitySubwayModelRhs(t, y, p)
  % 't': time
  % 'y': states
  % 'p': parameters
  
  % 'dy': dy/dt
  
  % define velocity v
  v = y(2);
  
  if t < 3.64338
    if v <  p.v1
      dyTemp = [  y(2) ; ...                                  % position
                  p.g * p.e * p.a1 / p.Weff / p.gamma ; ...   % velocity
                  p.p1 ];                                     % energy;
    else
      if v <  p.v2
        dyTemp = [  y(2) ; ...                                 % position
                    p.g * p.e * p.a2 / p.Weff / p.gamma ; ...  % velocity
                    p.p2 ];                                    % energy
      else
        dyTemp = [  y(2) ; ...                                                          % position
                    p.g * ( p.e * fun_T1(y(2)) - fun_R(y(2)) ) / p.Weff / p.gamma ; ... % velocity
                    p.e * fun_L1(y(2))];                                                % energy
      end
      
    end
  else
    if t < (8.96367 + 3.64338)
      if v <  p.v2
        dyTemp = [  y(2); ...  % position
                    0; ...     % velocity
                    0 ];       % energy;
      else
        if v <  p.v3
          dyTemp = [  y(2); ...                                % position
                      p.g * p.e * p.a3 / p.Weff / p.gamma; ... % velocity
                      p.p3];                                   % energy;
        else
          dyTemp = [  y(2); ...                                                          % position
                      p.g * ( p.e * fun_T2(y(2)) - fun_R(y(2)) ) / p.Weff / p.gamma;...  % velocity
                      p.e * fun_L2(y(2))];                                               % energy;
        end
      end
    else
      if t < (3.64338 + 8.96367 + 33.1757)
        if v <  p.v1
          dyTemp = [  y(2) ; ...                                  % position
                      p.g * p.e * p.a1 / p.Weff / p.gamma ; ...   % velocity
                      p.p1 ];                                     % energy;
        else
          if v <  p.v2
            dyTemp = [  y(2) ; ...                            % position
                  p.g * p.e * p.a2 / p.Weff / p.gamma ; ...   % velocity
                  p.p2 ];                                     % energy
          else
            dyTemp = [  y(2) ; ...                                                          % position
                        p.g * ( p.e * fun_T1(y(2)) - fun_R(y(2)) ) / p.Weff / p.gamma ; ... % velocity
                        p.e * fun_L1(y(2))];                                                % energy
          end
          
        end
      else
        if t < (3.64338 + 8.96367 + 33.1757 + 11.3773)
          if v <= 0
            dyTemp = [0; 0; 0];
          else
            dyTemp = [  y(2);...                                         % position
                        - p.g * fun_R(y(2)) / p.Weff - p.C / p.gamma;... % velocity
                        0];                                              % energy
          end
        else
          if v <= 0
            dyTemp = [0; 0; 0];
          else
            dyTemp = [  y(2); ...     % position
                  p.umax; ...   % velocity   % note:  p.umax = - 3.0/gamma = - 4.4 
                  0];       % energy
          end
        end
      end
    end
  end
  
  dy = dyTemp;
end