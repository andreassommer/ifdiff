# IFDIFF Live Demos Collection

The software package IFDIFF deals with the solution and algorithmic generation of sensitivities in ordinary differential equations with implicit (state-dependent) `non-differentiabilites` (`“switches”`) in the right-hand side that is given as Matlab program code with non-differentiable operators such as `min`, `max`, `abs`, `sign`, as well as `if-branching`. IFDIFF automatically generates only necessary switching functions, outputs them as Matlab code, and detects switching points accurately up to machine precision.

IFDIFF handles multidimensional state and parameter vectors and can be transparently used in existing code, as it generates sol solution structures compatible to the MATLAB ode solvers. No modifications to the right hand side or manual processing are necessary. A single preparation call is sufficient.

*Note: GitHub cannot display MATLAB live scripts (`.mlx`) directly in the browser.*
*To view them, please download the files and open them in MATLAB.*

Below is a short description of each demo done in IFDIFF:

---

### 1. [Basic Integration in IFDIFF](./canonicalExRHS_test_live.mlx)
Shows how to set up and run a simple IFDIFF integration, illustrating automatic detection of switching points in a canonical example and demonstrating failiure of a naive *ode45* integration.

---

### 2. [Computation of Sensitivities in IFDIFF](./CanonicalSensitivities.mlx)
Demonstrates the automatic generation and evaluation of sensitivities with respect to parameters and initial conditions, without manual coding of derivatives.

---

### 3. [Modeling State Jumps in IFDIFF](./StateJumpExample.mlx)
Illustrates how IFDIFF handles discontinuous dynamics with explicit state jumps, ensuring correct propagation of sensitivities across discontinuities.

---

### 4. [Parameter Estimation in a switched system](./WhiteCabbageLive.mlx)
Applies IFDIFF in a parameter estimation setting for a biological growth model with switching dynamics, showcasing gradient-based optimization.

---

### 5. [Modeling systems with Filippov behaviour](./FilippovLive.mlx)
Explores nonsmooth systems governed by Filippov dynamics, showing how IFDIFF manages sliding modes and switching manifolds accurately.

---

To use: Download IFDIFF, open MATLAB and click a link above to navigate to the corresponding Live Example file.