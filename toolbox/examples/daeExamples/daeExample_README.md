<script
  src="https://cdn.mathjax.org/mathjax/latest/MathJax.js?config=TeX-AMS-MML_HTMLorMML"
  type="text/javascript">
</script>


# Switched DAE Example

## Introduction


A **differential algebraic equation (DAE)** is a system that involves both differential equations and algebraic constraints. These systems may exhibit switching behavior, meaning the system dynamics change depending on certain conditions.
IFDIFF can solve such switched DAEs. 

Let's take a look at the following example for $t \in [0,n]$ where  $n \in \mathbb{N}$ :

$(D) \hspace{0.2cm} \begin{cases} \dot{x}_1  = f_1(x_2) = \begin{cases} x_2, \hspace{0.2cm} \text{if} \hspace{0.2cm} x_2 < p\\ 0 \hspace{0.2cm} \text{if} \hspace{0.2cm} x_2 \geq p \end{cases}  \\ f_2(x) = x_1 + x_2 = 0  \\ x_0 = (1,-1)^T, p \in \mathbb{R} \end{cases}$


## Analytical solution

The DAE $(D)$ is of index 1 since the algebraic constraint can be differentiated once to achieve $x_1 + x_2 = 0 \Rightarrow \dot{x_1} + \dot{x_2} = 0 \iff \dot{x_2} = - \dot{x_1}$ which then gives us the ODE system:

$(D_{\text{ODE}})$ $ \begin{cases} \dot{x}_1  = f_1(x_2) = \begin{cases} x_2, \hspace{0.2cm} \text{if} \hspace{0.2cm} x_2 < p\\ 0 \hspace{0.2cm} \text{if} \hspace{0.2cm} x_2 \geq p \end{cases}  \\ f_2(x) = - \dot{x_1} = \begin{cases} -x_2 \hspace{0.2cm} \text{if} \hspace{0.2cm} x_2 < p\\ 0 \hspace{0.2cm} \text{if} \hspace{0.2cm} x_2 \geq p \end{cases}   \\ x_0 = (1,-1)^T, p \in \mathbb{R} \end{cases} $

The system $(D_{\text{ODE}})$ will only exhibit switching behaviour at $p \in (-1,0)$ since:

1. Let $ p \leq -1 $ : 
At $t = 0 $ we have $x_2(0)= -1 \geq p$. Therefore $\dot{x}_2(t)=0$, meaning we stay in the second branch of $f_1$ and no switch occurs.

2. Let $p \geq 0 $ : 
At $ t = 0 $ we have $x_2(0)= -1 < p$.Therefore we only have $\dot{x_2} = - \dot{x_1} \Rightarrow x_1(t) = e^{-t}$ and $x_2(t) = -e^{-t} \hspace{0.2cm} \forall t \in I$. Since $-e^{-t} < 0 \leq p$, not switch occurs in this situation either.

3. So, let $p \in (-1, 0)$:
In this situation the system starts in case 2, so exponential growth in the 1st and exponential decay in the 2nd component.
We now determine the switching point $t_s \in (0,2)$. The switching point satisfies $x_2(t_s)=p$, so $x_2(t_s)=p \iff -e^{-t_s} = p \iff t_s = -\text{ln}(-p) $. (Remember that $-p$ is positive!)

We also notice from the formula $t_s = -\text{ln}(-p)$ that the switching point $t_s$ will be larger as $p$ gets smaller. This means, depending on the parameter, we need to choose a fitting time horizon $[0,n]$

## Solution with IFDIFF

Numerically, an index 1 DAE system is not solved by converting it to an ODE system. instead, MATLAB offers the solver `ode15s` for solving DAEs which we will use IFDIFF with.

### Step 1: Right Hand Side
We code the Right Hand Side (RHS) as follows.

```
function f = daeExampleRHS(~, x, p)
f = zeros(2,1);

% algebraic constraint
z = x(1) + x(2);
f(2) = z;

% differential variables
if x(2) < p
    f(1) = x(2);
else
    f(1) = 0;
end
```

### Step 2: Setup & Integration
For the main script, we first need to set up the initial value $x_0 = (1,-1)^T$ and a mass matrix $M$ such that the algebraic constant is set to 0 while the differential variables remain as coded in the RHS.
We now need to choose a parameter $ p \in (-1,0) $, e.g. $p = -0.5$ and a suitable time horizon, e.g. $[0,2]$. (You can choose any time horizon large enough to contain the switching point.).
At last for this step, we set up integrator options and the datahandle and then integrate using `solveODE`. To compare our solution with the solution by plain `ode15s`, we can call it with the same options as we set for IFDIFF.

```
integrator = @ode15s;
x0 = [1; -1];
tspan = [0 5];
M = [1 0; 0 0];
p = -0.5;

opts = odeset('Mass', M, 'MassSingular', 'yes', ...
                     'AbsTol', 1e-6, 'RelTol', 1e-3)
datahandle = prepareDatahandleForIntegration('daeExampleRHS', ...
                                             'integrator', integrator, 'options', opts;
sol_ifdiff = solveODE(datahandle, tspan, x0, p);
sol_plain = integrator(@(t, x) daeExampleRHS(t, x, p), tspan, x0, opts_ode);
```

### Step 3: Visualising

To look at our solution and compare them to the plain `ode15s` we can plot both in one plot as follows.

```
t = -2:0.0001:0;
fig = figure(123);
clf;
hold on
p1 = plot(sol_ifdiff.x, sol_ifdiff.y, 'ro');
p2 = plot(sol_plain.x, sol_plain.y, 'b');
legend([p1(1), p2(2)], {'IFDIFF','plain ode15s'});
hold off
```

This gives us the following plot:

% Plot fehlt noch

## Sensitivities

Analytically, the sensitivities of $(D)$ are computed by:


However, we can investigate the sensitivities with IFDIFF via
To further investigate this example go to `daeExample_main.m` and `daeExampleRHs.m`
