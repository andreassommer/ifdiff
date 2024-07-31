function FDstep = generateFDstep(dim_y, dim_p, varargin)
   % FDstep = generateFDstep(dim_y, dim_p, varargin)
   %
   % Generates struct with necessary information for the step size to calculate finite differences with respect to y, p and t. 
   % Here the calculation can be set to be performed relative or absolute to the point at which you calculate the finite difference.
   %
   % INPUT: dim_y    - length of the solution vector y(t) of the IVP evaluated at a timepoint t
   %        dim_p    - length of the parameter vector
   %        varargin - optional specification of certain parameters:
   %                   'hy'          - step size for the calculation of finite differences w.r.t. y (can be given as a scalar or a vector of dimension dim_y)
   %                   'hy_rel_flag' - flag that is true if the calcuation of the step size should be relative to the point at which the finite difference is calculated
   %                   'y_typ'   - vector that shows the typical magnitude of the entries of y
   %                   'hy_min'      - lower bound for the step size
   %                   (the same holds for p and t)
   %                   'h_dir'       - step size for calculating finite differences in the method END_full for directional derivatives (has to be given as a scalar)
   %
   % OUTPUT: FDstep - struct with necessary information for the step size to calculate finite differences
   
   % Defaults
   hy = 1e-6;
   hp = 1e-6;
   ht = 1e-6;
   h_dir = 1e-6;
   hy_rel_flag = true;
   hp_rel_flag = true;
   ht_rel_flag = true;
   y_typ = ones(dim_y, 1);
   p_typ = ones(dim_p, 1);
   t_typ = 1;

   if olHasOption(varargin, 'hy'), hy = olGetOption(varargin, 'hy'); end
   if olHasOption(varargin, 'hp'), hp = olGetOption(varargin, 'hp'); end
   if olHasOption(varargin, 'ht'), ht = olGetOption(varargin, 'ht'); end
   if olHasOption(varargin, 'h_dir'), h_dir = olGetOption(varargin, 'h_dir'); end
   if olHasOption(varargin, 'hy_rel_flag'), hy_rel_flag = olGetOption(varargin, 'hy_rel_flag'); end
   if olHasOption(varargin, 'hp_rel_flag'), hp_rel_flag = olGetOption(varargin, 'hp_rel_flag'); end
   if olHasOption(varargin, 'ht_rel_flag'), ht_rel_flag = olGetOption(varargin, 'ht_rel_flag'); end
   if olHasOption(varargin, 'y_typ'), y_typ = olGetOption(varargin, 'y_typ'); end
   if olHasOption(varargin, 'p_typ'), p_typ = olGetOption(varargin, 'p_typ'); end
   if olHasOption(varargin, 't_typ'), t_typ = olGetOption(varargin, 't_typ'); end
   
   hy_min = y_typ * 1e-10;
   hp_min = p_typ * 1e-10;
   ht_min = t_typ * 1e-10;
   
  if olHasOption(varargin, 'hy_min'), hy_min = olGetOption(varargin, 'hy_min'); end
  if olHasOption(varargin, 'hp_min'), hp_min = olGetOption(varargin, 'hp_min'); end
  if olHasOption(varargin, 'ht_min'), ht_min = olGetOption(varargin, 'ht_min'); end
   
   
   if (length(hy) == 1) && (dim_y > 1)
      hy = ones(dim_y, 1) * hy;
   end
   
   if (length(hp) == 1) && (dim_p > 1)
      hp = ones(dim_p, 1) * hp;
   end
   
   FDstep.y = hy;
   FDstep.y_rel = hy_rel_flag;
   FDstep.y_min = hy_min;
   FDstep.y_typ = y_typ;
   FDstep.p = hp;
   FDstep.p_rel =  hp_rel_flag;
   FDstep.p_min = hp_min;
   FDstep.p_typ = p_typ;
   FDstep.t = ht;
   FDstep.t_rel =  ht_rel_flag;
   FDstep.t_min = ht_min;
   FDstep.t_typ = t_typ;
   FDstep.dir = h_dir;  
end