# IFDIFF - A MATLAB Toolkit for ODEs with State˗Dependent Switches
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=andreassommer/ifdiff&file=toolbox/doc/GettingStarted.mlx)

The software package IFDIFF comprises:
- **Automatic detection and processing** of state-dependent switching events in ODE IVPs
- **Automatic generation** of only the necessary **switching functions** (exported as MATLAB code)
- Accurate switching point detection up to machine precision
- Detection and handling of **Filippov sliding modes**
- ODEs with state-jumps and model switches
- **Sensitivity generation** for switched ODEs, ODEs with state-jumps and Filippov ODEs

Sensitivities can be generated w.r.t. both initial values and parameters sets.

For a mathematical introduction and illustrative examples, see the  
[IFDIFF project page](https://andreassommer.github.io/ifdiff/).

A compact, self-explanatory MATLAB example is provided in this file. ([`Readme_Example.m`](./toolbox/examples/Readme_Example.m))


</br>


# Installation

There are two ways to install IFDIFF. The required [First Run Prerequisites](#first-run-prerequisites) are identical for both methods after installation.

## Installation Method A

1. Download the current release file `IFDIFF_Toolbox.mltbx`.
2. Open MATLAB and navigate to the directory containing the file.
3. Right-click the file and select **Open**.
4. For a detailed introduction, open `GettingStarted.mlx`, which is included with the toolbox.

Note: You can also open the Getting Started guide directly in MATLAB Online and then continue with the [First Run Prerequisites](#first-run-prerequisites).


## Installation Method B

1. Navigate to a location of your choice on your PC (e.g. Desktop).
2. Clone the repository `git clone https://github.com/andreassommer/ifdiff.git`
3. Open MATLAB and navigate to the cloned `ifdiff` directory.

</br>

# First Run Prerequisites

Before using IFDIFF, the script `make_mtreeplus` must be executed once. (In `ifdiff/toolbox` for installation Method B.) 
This script generates a modified copy of MATLAB's internal parser class `mtree`, which is required by IFDIFF.

In each new MATLAB session, initialize the required paths by calling:

`initIFDIFF();` 

This command can be executed either from the toolbox directory or from the cloned repository.

</br>

# Usage

Ensure that the [First Run Prerequisites](#first-run-prerequisites) have been completed. 
For a step-by-step usage example and background explanation, see the [IFDIFF  project page](https://andreassommer.github.io/ifdiff/).
