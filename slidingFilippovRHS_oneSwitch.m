function dy = slidingFilippovRHS_oneSwitch(datahandle, ctrlifCounter, switchingFunction,t,y,p)
   % Computes a Filippov right-hand-side w.r.t. the given 'ctrlifCounter', 
   % i.e., a convex-combination of the two models where the associated 
   % ctrlif evaluates to 0 and 1, respectively. 
   % Read [1] or [2, Chapter 1] for mathematical details.
   % 
   % INPUT:
   %    'datahandle'        --> Datahandle for a switched system.
   %    'ctrlifCounter'     --> Switch for which the convex-combination should be
   %                  	        computed.
   %    'switchingFunction' --> Switching function of the switch that is 
   %                            to be put in sliding mode (function handle).
   %    't'                 --> time, passed to the preprocessed RHS
   %    'y'                 --> state, passed to preprocessed RHS
   %    'p'                 --> parameters, passed to preprocessed RHS
   %
   % OUTPUT:
   %    'dy'                --> Value of the Filippov-RHS, determined as 
   %                            described above.
   %
   % Author: Michael Strik, Jun2024
   % Email:  michael.strik@stud.uni-heidelberg.de
   %         michi.strik@gmail.com
   % 
   % [1] A.F. Filippov. Differential Equations with Discontinuous Right
   % Hand Side. Kluwer Academic Publishers, Dordrecht, Boston, London, 1988.
   % [2] A. Meyer. Numerical Solution of Optimal Control Problems with 
   % Explicit and Implicit Switches. PhD thesis, Ruprecht-Karls-Universität 
   % Heidelberg, 2020.
   
   % evaluate RHS for ctrlif=0 using forced branching 
   data = datahandle.getData();
   data.forcedBranching.switch_cond_forcedBranching(ctrlifCounter) = 0;
   datahandle.setData(data);
   f_minus = datahandle.getData().integratorSettings.preprocessed_rhs(datahandle,t,y,p);

   % evaluate RHS for ctrlif=1
   data = datahandle.getData();
   data.forcedBranching.switch_cond_forcedBranching(ctrlifCounter) = 1;
   datahandle.setData(data);
   f_plus = datahandle.getData().integratorSettings.preprocessed_rhs(datahandle,t,y,p);

   FDstep = generateFDstep(length(y), length(p)); % TODO use relative finite differences (consider typical values of y and p)
   n = del_f_del_y(datahandle, switchingFunction, t, y, p, FDstep.y);
   % n (= d/dy switchingFunction) is an outer normal of switching manifold that we want to slide on

   n_dot_fplus  = dot(n,f_plus);
   n_dot_fminus = dot(n,f_minus);    

   % assemble alpha
   alpha = n_dot_fplus./(n_dot_fplus-n_dot_fminus);

   % SANITY CHECK
   % dot(n,f_plus) and dot(n, f_minus) can't have the same sign. otherwise we 
   % are not in sliding mode anymore and we can not rely on the formula for alpha 
   same_sign = (n_dot_fplus <= 0 & n_dot_fminus <= 0) | (n_dot_fplus >= 0 & n_dot_fminus >= 0);
   if any(same_sign)
       % dot(n,f_plus) and dot(n,f_minus) have the same sign
       pos = n_dot_fplus(same_sign)>0;
       neg = n_dot_fplus(same_sign)<0;
       alpha(pos) = zeros(1,length(alpha(pos)));
       % pos: n points into {swFct>=0}, so f_plus,f_minus point into {sigma>0}.
       % we continue with f_plus, set alpha=0
       alpha(neg) = ones(1,length(alpha(neg)));
       % neg: f_plus, f_minus point into {swFct<0}, continue with f_minus
   end

   % write alpha into datahandle
   data = datahandle.getData();
   data.sliding.alpha_last = alpha;
   datahandle.setData(data);
   
   dy = alpha*f_minus + (1-alpha)*f_plus;
   
end
