# Switched DAE Example

## Introduction

A **differential algebraic equation (DAE)** is a system of equations involving an unknown function and its derivatives together with algebraic equations, which impose constraints on the variables. Geometrically, the algebraic equations define a constraint manifold in the state space, and the solution trajectory of any DAE initial-value problem must remain on this manifold.

In applications, DAEs can be combined with state-dependent events (e.g. contact/no-contact, switching circuits), which leads to systems whose dynamics change when certain state conditions are met. IFDIFF can solve such switched DAEs.

Let's take a look at the following example for $t \in I = [0,n]$ where  $n \in \mathbb{N}$:

$$
(D) \quad
\begin{cases}
    \dot{x}_ 1 = f_1(x_2) = 
    \begin{cases} 
        x_2, & \text{if } x_2 < p \\
        0, & \text{if } x_2 \geq p
    \end{cases} \\
    f_2(x) = x_1 + x_2 = 0 \\
    x_0 = (1,-1)^T, p \in \mathbb{R}
\end{cases}
$$
 
## Analytical solution

First we derive the analytical solution of $(D)$. We see that the DAE is of index 1 since the algebraic constraint can be differentiated once to achieve $x_1 + x_2 = 0 \Rightarrow \dot{x_1} + \dot{x_2} = 0 \iff \dot{x_2} = - \dot{x_1}$ which then gives us the ODE system:

$$
(D_{\text{ODE}})
\begin{cases}
    \dot{x}_1 = f_1(x_2) =
    \begin{cases}
        x_2, & \text{if } x_2 < p \\
        0, & \text{if } x_2 \geq p
    \end{cases} \\
    \dot{x}_2 = - \dot{x_1} =
    \begin{cases}
        -x_2, & \text{if } x_2 < p \\
        0, & \text{if } x_2 \geq p
    \end{cases} \\
    x_0 = (1,-1)^T, p \in \mathbb{R}
\end{cases}
$$

The system $(D_{\text{ODE}})$ will only exhibit switching behaviour at $p \in (-1,0)$ since:

1. Let $p \leq -1:$ At $t = 0$ we have $x_2(0)= -1 \geq p$. Therefore $\dot{x}_ 2(t)=0$, meaning we stay in the second branch of $f_1$ and no switch occurs.
2. Let $p \geq 0:$ At $t = 0$ we have $x_2(0)= -1 < p$. Therefore we only have $\dot{x_2} = - \dot{x_1} \Rightarrow x_1(t) = e^{-t}$ and $x_2(t) = -e^{-t} \quad \forall t \in I$. Since $-e^{-t} < 0 \leq p$, no switch occurs in this situation either.
3. So, let $p \in (-1, 0)$: In this situation the system starts in case 2, so exponential growth in the 1st and exponential decay in the 2nd component. We now determine the switching point $t_s \in (0,2)$. The switching point satisfies $x_2(t_s)=p$, so $x_2(t_s)=p \iff -e^{-t_s} = p \iff t_s = -\text{ln}(-p) $. (Remember that $-p$ is positive!)

We also notice from the formula $t_s = -\text{ln}(-p)$ that the switching point $t_s$ will be larger as $p$ gets smaller. This means, depending on the parameter, we need to choose a fitting time horizon $I = [0,n]$.

## Solution with IFDIFF

In practice, DAE systems are not solved by converting them to an ODE systems. Instead, MATLAB offers the solver `ode15s` for solving DAEs which we will use IFDIFF with.

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
For the main script, we set up a consistent initial value, e.g. $x_0 = (1,-1)^T$ and a mass matrix $M$ such that the algebraic constraint is set to 0 while the differential variables remain as coded in the RHS.
We choose a parameter $p \in (-1,0)$, e.g. $p = -0.2$ and a suitable time horizon, e.g. $I = [0, 5]$.

```
integrator = @ode15s;
x0         = [1; -1];
tspan      = [0 5];
M          = [1 0; 0 0];
p          = -0.2;

opts_ifdiff = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-9, 'RelTol', 1e-6);
opts_plain  = odeset('Mass', M, 'MassSingular', 'yes', 'AbsTol', 1e-9, 'RelTol', 1e-6);

datahandle = prepareDatahandleForIntegration('daeExampleRHS', 'integrator', integrator, 'options', opts_ifdiff);
sol_ifdiff = solveODE(datahandle, tspan, x0, p);
sol_plain  = integrator(@(t, x) daeExampleRHS(t, x, p), tspan, x0, opts_plain);
```

### Step 3: Visualising

To look at our solution and compare them to the plain `ode15s`, we can plot both in one plot as follows.

```
fig1 = figure(01);
hold on
IFDIFF_plot_1 = plot(sol_ifdiff.x, sol_ifdiff.y, 'ro--', 'DisplayName', 'IFDIFF'); 
Plain_plot_1  = plot(sol_plain.x, sol_plain.y, 'ko-', 'DisplayName', 'plain ode15s');
Switch_plot   = xline(sol_ifdiff.switches, 'g', 'LineWidth', 1.0, 'DisplayName', 'Switch');
legend([Plain_plot_1(1), IFDIFF_plot_1(1), Switch_plot]);
hold off
```

![](plots_daeExample/plot1.png)

We notice that the integrator strategy results in small steps here for the plain solver as well as IFDIFF. This is standard behavior for `ode15s` which is a multi-step method; it is not a defect caused by improper treatment of switching events.
However, if we take a closer look, we see that the integration with IFDIFF is accurate around the switching point. 

![](plots_daeExample/plot1_close2.png)

## Additional Content

To further investigate this example, take a look at the files `daeExample_main.m` and `daeExampleRHs.m`. 
Additionally, go to the folder `rlcExample` to learn about solving DAEs with IFDIFF in a modelling example.
