% Use this script to read out and plot .arf file created by BioSigRz (TDT) 
%
% Use this code for troubleshooting the ABR part of AcousticPlotter. 
% Created by Steve McI 2022



warning('off','all')
clear all
close all
clc

addpath('FunctionsFolder')

%% find file

% [file,path] = uigetfile('*.mat', 'Select a file', 'C:\Users\Steve\Documents\Data');

file = 'PBM_ABR_round2_Pre_Reorganized.mat';
% path = "C:\Users\stevemci\Box\Stephen McInturff's Files\PBM\";
% mouse = 17;
% file = 'Example ABR.mat';
path = "C:\Users\stevemci\Box\Stephen McInturff's Files\AcousticPlotter_forGithub - Copy\Files\";
% path = "C:\Users\stevemci\Box\Stephen McInturff's Files\AcousticPlotter_forGithub - Copy\Examples\";
mouse = 1;

%% extract data 

data = load(fullfile(path, file));

%% plot data

clc
app = plotABRs; 
startfunc(app, strrep(file, '.mat', ''), data.details(mouse), data.thresh(mouse));
waitfor(app)




