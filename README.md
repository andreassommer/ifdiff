# Workshop: Thursday, July 09, 2026

## Filippov-ODEs and DAEs with State-dependent Switches

**Theory and Hands-On Practical with IFDIFF**

**Thursday, July 09, 2026 • 9:00–16:00**

Mathematikon • CIP Pools 3rd Floor • and **Online**  
Im Neuenheimer Feld 205 • 69120 Heidelberg

Participation is free. [Register here!](https://t1p.de/ifdiff2026)

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

## Installation

There are two ways to install IFDIFF locally. Alternatively, you may use IFDIFF without any local installation in the cloud-based "MATLAB Online" environment. In that case, simply press the "Open in MATLAB Online" button below to import the IFDIFF repository in MATLAB Online.

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=andreassommer/ifdiff&file=toolbox/doc/GettingStarted.mlx)

### Install Toolbox (Recommended)

1. Download the IFDIFF toolbox file (`IFDIFF_Toolbox_vXXX.mltbx`) from the [releases page](https://github.com/andreassommer/ifdiff/releases/latest).
2. Open MATLAB and navigate to the directory containing the toolbox file.
3. Install the toolbox file:
    - From the GUI (recommended):
        - **MATLAB R2025a or newer**: Double click the toolbox file in the MATLAB Files panel.
        - **MATLAB R2024b or older**: Right-click the toolbox file in the MATLAB Current Folder browser and select **Install**.

    - From the command window (alternative):
        - **MATLAB R2016a or newer**: Run the following command in the MATLAB Command Window (after replacing the placeholder text `'IFDIFF_Toolbox_vXXX.mltbx'` with the actual name of your toolbox file):

        ```MATLAB
        matlab.addons.toolbox.installToolbox('IFDIFF_Toolbox_vXXX.mltbx');
        ```

4. For a practical introduction to IFDIFF, view the Getting Started Guide (`GettingStarted.mlx`). The guide should open automatically after installing the toolbox file from the GUI.  
You can also open the guide manually:
    - From the MATLAB Add-On Manager (recommended):
        1. Open the MATLAB Add-On Manager (Home tab > Environment section > Add-Ons > Manage Add-Ons).
        2. Find the "IFDIFF Toolbox" Add-On in the list of installed Add-Ons.
        3. Open the context menu by right-clicking the "IFDIFF Toolbox" Add-On or clicking on the three dots that appear on the right when hovering over the "IFDIFF Toolbox" Add-On.
        4. Click on the "View Getting Started Guide" button in the context menu.
    - From the file browser (alternative):
        1. Open the toolbox installation folder. See the [MATLAB Documentation on the Default Add-On Installation Folder](https://www.mathworks.com/help/matlab/matlab_env/get-add-ons.html#buy5hl8-1) for detailed instructions on how to find the installation folder.
        2. In the toolbox folder, navigate to the subfolder `doc` and open the file `GettingStarted.mlx` in MATLAB.

### Install Full Repository (Alternative)

1. Navigate to a location of your choice on your PC (e.g. Desktop).
2. Clone the repository `git clone https://github.com/andreassommer/ifdiff.git`.
3. Open MATLAB and navigate to the cloned `ifdiff` directory.
4. For a practical introduction to IFDIFF, open the Getting Started Guide (`GettingStarted.mlx`) in MATLAB. You can find the guide in the subfolder `toolbox/doc` contained in the cloned `ifdiff` directory.

## Usage

For a step-by-step usage example and background explanation, see the [IFDIFF  project page](https://andreassommer.github.io/ifdiff/).

Afterwards, you can check out our Getting Started Guide in MATLAB for a hands-on walkthrough on how to use IFDIFF. If you have trouble finding the Getting Started Guide, please refer to the last step of the [installation section](#installation) for [toolbox installations](#install-toolbox-recommended) or [full repository installations](#install-full-repository-alternative) (whichever applies in your case).

### Prerequisites

#### One-Time Setup (required for all installation types)

After installing IFDIFF for the first time, you must run the following command in the MATLAB Command Window before you can start using IFDIFF:

```MATLAB
initIFDIFF
```

After running the command, you will receive a prompt in the Command Window asking you to let IFDIFF generate the `mtreeplus` class, which is a copy of MATLAB's internal parser class `mtree` on which IFDIFF heavily relies. Enter `y` in the Command Window to proceed and wait for the script to finish running. At the end you should see a message confirming that the `mtreeplus` class was generated successfully.

#### On Each MATLAB Session (required only for non-toolbox installations)

If you have not installed IFDIFF as a toolbox, then you must manually setup the MATLAB path to access IFDIFF functions on each MATLAB session before you can use IFDIFF. To do this, simply run the following command in the MATLAB Command Window:

```MATLAB
initIFDIFF
```
