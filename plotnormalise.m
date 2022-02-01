clc;
close all;

files=dir('parked wide scan.mat');
files1=dir('use this to normalise.mat');

load(files1.name)
T_unpark=NaN(length(scanData.T)+1e2,1);
T_unpark(1:length(scanData.T))=scanData.T(1:length(scanData.T));
W=NaN(length(T_unpark),length(files));
T_norm=NaN(length(T_unpark),length(files));

for i=1:length(files)
    load(files(i).name)
    W(1:length(scanData.W),i)=scanData.W(1:length(scanData.W));
    T_norm(1:length(scanData.T),i)=scanData.T(1:length(scanData.T))./T_unpark(1:length(scanData.T));
end

for i=1:length(files)
    plot(W(:,i),T_norm(:,i));
    xlim([940,985])
    xlabel('Wavelength (in nm)','FontSize',40)
    ylabel('Transmission (in arb. units)','FontSize',40);
    title('Normalised wide scan')
    set(gca,'FontSize',20)
end
    
