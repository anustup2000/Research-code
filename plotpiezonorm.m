clc;
close all;

files=dir('* at nm.mat');


T_scan=scanData.T;
T_max=max(scanData.T);
T_norm=T_scan/T_max;
W_scan=scanData.W;
