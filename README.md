# IFDIFF - A Matlab Toolkit for ODEs with State˗Dependent Switches

The software package IFDIFF deals with the solution and algorithmic generation of sensitivities in
ordinary differential equations with implicit (state-dependent) non-differentiabilites ("switches") 
in the right-hand side that is given as Matlab program code with non-differentiable operators such as
`min`, `max`, `abs`, `sign`, as well as `if`-branching. IFDIFF automatically generates only necessary
switching functions, outputs them as Matlab code, and detects switching points accurately up to 
machine precision.

Sensitivities can be generated w.r.t. the initial values and w.r.t. a given parameter set

See the [IFDIFF page](https://andreassommer.github.io/ifdiff/) for a mathematical introduction with example.

The file [Readme_Example.m](./Readme_Example.m) contains a self-explaining Matlab script similar to the
 contents below.

</br>



# First Run Prerequisites
Before using IFDIFF, it is mandatory to run the `make_mtreeplus` script once.  
After starting Matlab, change to the IFDIFF directory and type `make_mtreeplus`.  
This scripts generates a modified copy of Matlab's own parser class `mtree`, on which IFDIFF heavily relies.

It is also advisable to initialize the paths needed for IFDIFF by invoking 
`initPaths();` once on every new matlab session.

</br>



# Usage

Make sure that you've followed the [First Run Prerequisites](#first-run-prerequisites).

The following commands exemplarily show the usage on the canonical example.

## 1. Preprocessing of Right Hand Side

The preprocessing analyses and transforms the right hand side function `canonicalExampleRHS.m`.
Preprocessing generates the `datahandle`, the central structure for switching detection and handling.  
We set ODE solver and its options as usual. If not set, default values are used.

   ```matlab
      initPaths();  % Initialise the paths for ifdiff
      integrator = @ode45; 
      odeoptions = odeset('AbsTol', 1e-14, 'RelTol', 1e-12);
      datahandle = prepareDatahandleForIntegration('canonicalExampleRHS', 'solver', func2str(integrator), 'options', odeoptions);
   ```


## 2. Integration (Forward Solution)

Define initial values, parameter values, and integration horizon, and call `solveODE` to start the integration.
`solveODE` returns a Matlab `sol` structure, that can be evalated using `deval`. 
It is an augmented version of the solution structures returned by  Matlab's very own integrator suite
(see https://de.mathworks.com/help/matlab/ref/deval.html#bu7iw_j-sol)

   ```matlab
      tspan         = [0 20];
      initialvalues = [1;0];
      parameters    = 5.437;
      sol = solveODE(datahandle, tspan, initialvalues, parameters); 
      T = 0:0.1:20;  
      X = deval(sol,T);
      plot(T,X)
```


## 3. Sensitivity Generation

The sensitivity generation currently supports 1st order forward sensitivities w.r.t. initial state and parameters.
It is possible to generate sensitivities using external numerical differentiation (flags `END_full`, `END_piecewise`)
or using the variational differential equations (flag `VDE`).  

Usually, method `VDE` delivers vest results in terms of accuracy, as it calculates error-controlled sensitivities. 
It uses the variational differential equations on each interval and performes updates at the switching points to 
ensure accurate sensitivities at the precalculated forward solution. However, the occuring augmented differential 
system might be large size and thus slow to compute.  
Required state derivatives of the right hand side are approximated using automated finite differencing.

The method `END_piecewise` computes the interval sensitivities using external numerical differentiation (finite differencing)
and connects these using the same updates as used in the VDE method. This requires multiple evaluations of interval solutions,
but might be faster on larger systems.  

When using `END_full`, external numerical differention is used on multiple full horizon solutions. The individual
trajectories are calculated with switching point detection. Thus, no updates between switches are required. 
In general, this approach is less accurate and slower than `END_piecewise`, but might be the a good choice 
for highly instable ODEs. 

1. Choose step sizes for finite differencing (also used in method `VDE` for generating state derivatives of the rhs). 

   ```matlab
      dim_y  = size(sol.y,1);                // state dimension
      dim_p  = length(parameters);           // number of parameters
      FDstep = generateFDstep(dim_y,dim_p);
   ```

   The `generateDFstep` function accepts several options influencing e.g. step length. 
   See the documentation or the file for more information


2. Build the sensitivity function. In this example, the `END_piecewise` method is chosen.

   ```matlab
      sensitivity_function = generateSensitivityFunction(datahandle, sol, FDstep, 'method', 'END_piecewise'); 
   ```

   The following table lists several name-value pairs that can be used to configure `generateSensitivityFunction`

   | Parameters              |   Possible values                                                                   | Defaults                              |
   | ----------------------- | ----------------------------------------------------------------------------------- | ------------------------------------- |
   | calcGy                  | true/false - flag indicating to calculate state sensitivities                       | true                                  |
   | calcGp                  | true/false - flag indicating to calculate parameter sensitivities                   | true                                  |
   | Gmatrices_intermediate  | true/false - flag indicating to store update matrics                                | false                                 |
   | save_intermediates      | true/false - flag indicating to store intermediate calculations                     | true                                  |
   | integrator              | Function handle for ODE solver in Matlab (e.g. ode45)                               | Integrator used by ifdiff             | 
   | integrator_options      | Options struct generated for ODE solver                                             | Integrator options used by ifdiff     |
   | method                  | String with VDE/END_piecewise/END_full                                              | VDE                                   |
   | directions_y            | Matrix containing directions for directional derivatives w.r.t initial values.      | Identity matrix with dimension n_y    |
   | directions_p            | Matrix containing directions for directional derivatives w.r.t parameters.          | Identity matrix with dimension n_p    |


3. Evaluate the sensitivity function at specific times. 

   ```matlab
      t = 0:0.1:20;
      sensitivities = sensitivity_function(t);
   ```
