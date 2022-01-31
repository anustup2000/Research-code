function [ params ] = Singlet_With_Thermal_Shift_T_Param_Guess( Lambda, Signal, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        
    %Make plot and request input
    fig=figure();
    plot(Lambda,Signal)
    title('Please click the FWHM of each resonance')
    xlabel('\lambda [nm]')
    ylabel('T')

    hold on
    
    lambdaFWHMPoints=NaN(1,2);   
    signalFWHMPoints=NaN(1,2);
    FWHMIndices=NaN(1,2);
    for i=1:2
        [lambdaFWHMPoints(i),~]=ginput(1);
        signalFWHMPoints(i)=interp1(Lambda,Signal,lambdaFWHMPoints(i));
        [~,FWHMIndices(i)]=min(abs(lambdaFWHMPoints(i)-Lambda));
        plot(lambdaFWHMPoints,signalFWHMPoints,'ro')
    end
    
    lambdaFWHMPoints(1:2)=sort(lambdaFWHMPoints(1:2));
    FWHMIndices = [sort(FWHMIndices(1:2))];
    
    Lambda_s_shifted=mean(lambdaFWHMPoints(1:2));
        
    %Guess input parameters, plot, and ask for user verification 
      
    [~,Lambda_s_Ind] = min(Signal(FWHMIndices(1:2)));     
    Lambda_s = Lambda(FWHMIndices(1)-1+Lambda_s_Ind);
    
     [~,Lambda_a_Ind] = min(Signal(FWHMIndices(3:4))); 
    Lambda_a = Lambda(FWHMIndices(3)-1+Lambda_a_Ind);
    
    %Center wavelength:
    Lambda_o = mean([Lambda_s Lambda_a]);
    
    [~,Lambda_s_Index] = min(abs(Lambda_s-Lambda));
   
    [~,Lambda_a_Index] = min(abs(Lambda_a-Lambda));
    
    
    %Loaded quality factors:
    Q_s =Lambda_o/(lambdaFWHMPoints(4)-lambdaFWHMPoints(3));
    Q_a=Lambda_o/(lambdaFWHMPoints(2)-lambdaFWHMPoints(1));
    
    %Resonance contrast:
    RC_s =1-Signal(Lambda_s_Index );
    RC_a=1-Signal(Lambda_a_Index);
    
    %External coupling quality factor
    Q_ex= 2*Q/(RC);
    Q_ex=(Q_ex_s+Q_ex_a)/2; %(Assume the external coupling is equal)
    
    %Intrinsic quality factors  
    Q_i =Q_ex* Q_s /(Q_ex -Q_s);
    Q_a_i=Q_ex_a*Q_a/(Q_ex_a-Q_a);
    
    params(1)=Lambda_o;
    params(2)=Q_ex;
    params(3)=Q_s_i;
    params(4)=Q_a_i;
    params(5)=Q_bs;
    params(6)=0.1; %Lambda_f; %Assume to be near the cavity center wavelength
    
    %This should be modified to handle the reflection case
    Tfit=Doublet_T(params, Lambda, 1);
    hold off
    plot(Lambda,Signal,Lambda,Tfit)
    xlabel('\lambda [nm]')
    %if(strcmpi(measurementType,'T'))
        ylabel('T')
%     elseif(strcmpi(measurementType,'R'))
%         ylabel('R')
%     end
       
    %Ask user to accept the fit
    response = questdlg('Accept preliminary fit?', ...
        '', ...
        'Yes','No','Yes');
    if strcmpi(response,'No')
        close(fig)
        DoubletParamGuess(Lambda, Signal);
    else
        close(fig)
    end
        
    %disp(num2str(Tfit))
    
end

