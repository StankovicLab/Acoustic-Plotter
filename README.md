# AcousticPlotter
#### A stand-alone Matlab application for viewing, comparing, and selecting thresholds of ABR and DPOAE data.
[![Language](https://img.shields.io/badge/Language-MATLAB-important)](https://www.mathworks.com/products/matlab.html)  [![MIT License](https://img.shields.io/github/license/Murray-Bartho/DPOAE-Analyzer)](https://github.com/StankovicLab/Acoustic-Plotter/blob/main/LICENSE) [![DOI](https://zenodo.org/badge/545105188.svg)](https://zenodo.org/badge/latestdoi/545105188)

<p align="center">
	<img src="Assets/MouseICON.jpg" width="256" height="256" alt="hi" class="inline"/>
</p>

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

## Citing AcosuticPlotter

If you used this program in your research, please cite it! 

All versions of `AcousticPlotter` can be **cited using its DOI** as seen below.  

> McInturff & Stankovic (2022). AcousticPlotter: A stand-alone Matlab application for viewing, comparing, and selecting thresholds of ABR and DPOAE data. DOI 10.5281/zendodo.7412173

## AUTHORS

    Stephen McInturff Ph.D - Lead Developer
    Konstantina Stankovic M.D. Ph.D.

[Lab Website](https://med.stanford.edu/stankovic-lab.html)

## FUNDING

    We gratefully acknowledge support from the Project Geneva/ Uniformed Services University of the Health Sciences grant HU00011920056, the Remondi Foundation, WayVector, and Bertarelli Foundation endowed professorship (KMS).
    
## UPDATE

v2.0 - 1/12/2023 
- added ability to find ABR peaks.

V2.1 - 2/28/2023 
- fixed a number of bugs
- got rid of opening dialog box "What file type would you like to open? ARF MAT". Now takes care of determining file type automatically

V2.2 - 3/31/2023 
- fixed a number of bugs 
- added scaling functionality
- added ability to return to starting page

V3 - 5/11/2023 
- fixed saving MATLAB figure bug
- corrected DPOAE conversion to dB SPL by adding mic sensitivity and gain settings
- added ability to find DPOAE threshold using a criterion or based on noise floor

V3.1 - 5/26/2023 
- Changed the filter from a Butterworth filter to a FIR filter which has superior temporal properties.
- Added a feature to correct for any gain used in the acquisition  of ABRs.

V3.2 - 9/27/2023 
- Fixed error that occured when a level was 'redone' and there are two of the same frequency and level in a file. The program will ignore all but the newest recording.
- When electrodes are placed incorrectly (pinna on vertex and vertex on pinna), the waveform is inverted. Added functionality to reinvert waveform.

