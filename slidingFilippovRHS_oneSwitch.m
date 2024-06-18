function dy = slidingFilippovRHS_oneSwitch(datahandle, ctrlif_index, switchingFunction,t,y,p)
   % Computes a Filippov right-hand-side w.r.t. the given 'ctrlif_index', i.e.,
   % a convex-combination of the two models where the associated ctrlif 
   % evaluates to 0 and 1, respectively. 
   % Read [1] or [2, Chapter 1] for mathematical details.
   % 
   % INPUT:
   %    'datahandle'   --> Datahandle for a switched system.
   %    'alpha'        -->  Parameter for convex-combination.
   %    'ctrlif_index' -->  Switch for which the convex-combination should be
   %                  	    computed.
   %    't'            -->  time, passed to the preprocessed RHS
   %    'y'            -->  state, passed to preprocessed RHS
   %    'p'            -->  parameters, passed to preprocessed RHS
   %
   % OUTPUT:
   %    'dy'           -->  Value of the Filippov-RHS, determined as 
   %                        described above.
   %
   % Author: Michael Strik, Jun2024
   % Email:  michael.strik@stud.uni-heidelberg.de
   %         michi.strik@gmail.com
   % 
   % [1] A.F. Filippov. Differential Equations with Discontinuous Right
   % Hand Side. Kluwer Academic Publishers, Dordrecht, Boston, London, 1988.
   % [2] A. Meyer. Numerical Solution of Optimal Control Problems with 
   % Explicit an Implicit Switches. PhD thesis, Ruprecht-Karls-Universität 
   % Heidelberg, 2020.
    
   % evaluate RHS for ctrlif=0 using forced branching
   data = datahandle.getData();
   data.ctlrifCase = 1; % QUESTION: Do I have to set it back to original in the end?

   data.forcedBranching.switch_cond_forcedBranching(ctrlif_index) = 0;
   datahandle.setData(data);
   f_minus = datahandle.getData().integratorSettings.preprocessed_rhs(datahandle,t,y,p);

   % evaluate RHS for ctrlif=1
   data = datahandle.getData();

   data.forcedBranching.switch_cond_forcedBranching(ctrlif_index) = 1;
   datahandle.setData(data);
   f_plus = datahandle.getData().integratorSettings.preprocessed_rhs(datahandle,t,y,p);
    
   FDstep = generateFDstep(length(y), length(p));
   dsigma_y = diff_sigma_y(datahandle, switchingFunction, t, y, p, FDstep.y);

   % assemble alpha
   alpha = dot(dsigma_y,f_plus)/dot(dsigma_y,f_plus-f_minus);

   dy = alpha*f_minus + (1-alpha)*f_plus;
   
end
