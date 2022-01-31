
% Assign values to variables
x = scanData.W; % nm

% for i=1:18
y = scanData.T; %volts

% Input for Estimating parameters for fits

h = figure;
plot(x,y,'.')
% xlim([3450000 3600000])
% ylim([0 2.5e-4])
title('Please select FWHM followed by minimum')
%[x,y] = ginput(n)
[fitEst] = ginput(3);
close(h)


% Estimate parameters for fits

CeilingEst=mean(y(1:floor(length (x)/5)));
% Floor rounds a number to the next smaller integer.
FWHM=fitEst(2,1)-fitEst(1,1); %nm
% params=[Amplitude FWHM Gaussian_mean Floor]
params=[(fitEst(3,2)-CeilingEst) FWHM fitEst(3,1) CeilingEst];
options   = optimset('MaxFunEvals',1E3,'MaxIter',1E3,'TolFun',1E-15,'TolX',1E-15,'Display','off','Jacobian','off');
% options   = optimset('MaxFunEvals',1E3,'MaxIter',1E3);



% Fitting functions
% Comb            = @(params,Freq) params(1)./(1+params(2)*(sin(params(3)*Freq)).^2)+params(4); %(Not currently used)
Lorentzian      = @(params,x) -params(1)*(params (2)/2)^2./((params (2)/2)^2+(x-params(3)).^2)+params(4);
% NoiseFloor      = @(params,Freq) params(1)*ones(length(Freq),1);


%x = lsqcurvefit(fun,x0,xdata,ydata,lb,ub,options)
[params,resNorm]=lsqcurvefit(Lorentzian,params,x,y.',[],[],options);

f=figure;
plot(x,y,'.',x,Lorentzian(params,x))
%close(f)

gamma_tot = 2*pi*params(2);
Q_m = params (3)/params(2);
disp(['Q= ' num2str(Q_m)])
disp(["AMplitude= "num2str(params(1))  num2str(params(2)) " " num2str(params(3)) " " num2str(params(4))])
%Resonance4_id_Q_Freq_Amp_floor(i,1:5)=[i+46,Q_m,params(3),params(1),params(4)];
%end
