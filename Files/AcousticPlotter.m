
% Use this script to read out and plot .arf file created by BioSigRz (TDT) 
% Can save data as an excel file or as a matlab data file.
% 
% Created by Stephen McInturff 2022 
% part of of the Stankovic Lab
% Otolaryngology Department, Stanford University 

% clear all variables, all text in command window, close all figures, and turn off warnings
clear all
clc
close all
warning off

% add folders that may contain functions
addpath('FunctionsFolder')
addpath('automaticThreshold')

% defite what app to use
app = AcousticPlotterStartGUI;
% call app
startfuncmaster(app);
% wait until app has been closed to continue
waitfor(app)



