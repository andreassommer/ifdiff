# README Differential Algebraic Equation Example (from Workshop 2026)

The mathematical formulation for ´rhsDaeExampleWorkshop.m´
Let $t \in [0,3]$, $\text{x} = (x_1, x_2)^T$:

$$
	(D) \quad
	\begin{cases}
		\dot{x}_ 1 = f(t,x,p) = 
		\begin{cases} 
			x_2, & \text{if } x_2 < p \\
			0, & \text{if } x_2 \geq p
		\end{cases} \\
		g(t,x,p) = x_1 + x_2 + 10(x_1^5 + x_2^3) = 0 \\
		\text{x}_0 = (1.0, -1.0)^T, p = -0.3
	\end{cases}
$$ 

On a larger scale, ´ode15s´ solution looks correct, but it fails around the switch at $t_s \approx 1.068$. When we zoom in, we see that ´ode15s´ does not notice the switch but instead fits a polynomial where the dynamics should change to constant immediately.
Since ´ode15s´  assumes a continuously differentiable solution trajectory and does not feature switching point detection, it is the wrong means of solving this problem.
