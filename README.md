# AcousticPlotter
#### A stand-alone Matlab application for viewing, comparing, and selecting thresholds of ABR and DPOAE data.
[![Language](https://img.shields.io/badge/Language-MATLAB-important)](https://www.mathworks.com/products/matlab.html)  [![MIT License](https://img.shields.io/github/license/Murray-Bartho/DPOAE-Analyzer)](https://github.com/StankovicLab/Acoustic-Plotter/blob/main/LICENSE)

<p align="center">
	<img src="Assets/MouseICON.jpg" width="256" height="256" alt="hi" class="inline"/>
</p>

### AUTHOR:

Created by Stephen McInturff 2022 as part of the Stankovic Lab at Stanford University
email: stephen_mcinturff@stanford.edu

## SUMMARY:
Application for veiwing and finding thresholds of ABRs and DPOAEs created by the TDT software [BioSigRZ](https://www.tdt.com/component/biosigrz-abr-dpoae-software/)

## DESCRIPTION:
Use this application to open .arf files created by TDT [BioSigRZ](https://www.tdt.com/component/biosigrz-abr-dpoae-software/) software. Can view ABRs and DPOAEs and export data as Excel or as Matlab data.

Thresholds are semiautomatically determined
DPOAE thresholds are determined when DP's are greater than 3x the standard deviation above the mean. ([Bartho et al. 2020](https://github.com/CDTbot/CDTbot))
ABR thresholds are determined using a method of cross correlation described by [Suthakar & Liberman 2019](https://doi.org/10.1016/j.heares.2019.107782)

## CONTENTS

- [Installer](https://github.com/StankovicLab/Acoustic-Plotter/tree/main/Installer)
- [Documentation](https://github.com/StankovicLab/Acoustic-Plotter/blob/main/documentation.md)
- [Write Up](https://github.com/StankovicLab/Acoustic-Plotter/blob/main/paper.md)
- [Matlab Code](https://github.com/StankovicLab/Acoustic-Plotter/tree/main/Files)
- [Examples](https://github.com/StankovicLab/Acoustic-Plotter/tree/main/Examples)
- [HotKeys](https://github.com/StankovicLab/Acoustic-Plotter/blob/main/hotkeys.md)
- [convertARFtoMAT](https://github.com/StankovicLab/Acoustic-Plotter/tree/main/convertARFtoMAT)
