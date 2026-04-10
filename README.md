# Workshop: Thursday, July 09, 2026
## Filippov-ODEs and DAEs with State-dependent Switches

**Theory and Hands-On Practical with IFDIFF**
**Thursday, July 09, 2026**

Time: 9–16h • Place: CIP Pool 1 & 2 • 3rd Floor • Mathematikon
Im Neuenheimer Feld 205 • 69120 Heidelberg and **Online**

Participation is free. Register here: https://t1p.de/ifdiff2026


# IFDIFF - A MATLAB Toolkit for ODEs with State˗Dependent Switches
[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=andreassommer/ifdiff&file=toolbox/doc/GettingStarted.mlx)

The software package IFDIFF comprises:
- **Automatic detection and processing** of state-dependent switching events in ODE IVPs
- **Automatic generation** of only the necessary **switching functions** (exported as MATLAB code)
- Accurate switching point detection up to machine precision
- Detection and handling of **Filippov sliding mode**
- ODEs with state-jumps and model switches
- **Sensitivity generation** for switched ODEs, ODEs with state-jumps and Filippov ODEs

Sensitivities can be generated w.r.t. the initial values and w.r.t. a given parameter set.

For a mathematical introduction and illustrative examples, see the  
[IFDIFF project page](https://andreassommer.github.io/ifdiff/).

A compact, self-explanatory MATLAB example is provided in this file. ([`Readme_Example.m`](./toolbox/examples/Readme_Example.m))


</br>


# Installation

There are two ways to install IFDIFF.

## Installation Method (Recommended)

1. Download the current release file `IFDIFF_Toolbox.mltbx`.
2. Open MATLAB and navigate to the directory containing the file.
3. Right-click the file and select **Install**.
4. For a detailed introduction, open `GettingStarted.mlx`, which is included with the toolbox.

Note: You can also open the Getting Started guide directly in 
[MATLAB Online](https://matlab.mathworks.com/open/github/v1?repo=andreassommer/ifdiff&file=toolbox/doc/GettingStarted.mlx) and then continue with the [First Run Prerequisites](#first-run-prerequisites).

## Installation Method (Alternative)

1. Navigate to a location of your choice on your PC (e.g. Desktop).
2. Clone the repository `git clone https://github.com/andreassommer/ifdiff.git`
3. Open MATLAB and navigate to the cloned `ifdiff` directory.

</br>

# Usage

Once every new MATLAB session run

 `initIFDIFF();` 

to initialize the required paths. Then IFDIFF is ready to use. 

The first time the command is executed, a copy of MATLAB's internal parser class `mtree` is created on which IFDIFF heavily relies.
For a step-by-step usage example and background explanation, see the [IFDIFF  project page](https://andreassommer.github.io/ifdiff/).
