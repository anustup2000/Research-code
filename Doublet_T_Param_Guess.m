function [ params ] = Doublet_T_Param_Guess( Lambda, Signal, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        
    %Make plot and request input
    fig=figure();
    plot(Lambda,Signal)
    title('Please click the FWHM of each resonance')
    xlabel('\lambda [nm]')
    ylabel('T')

    hold on
    
    lambdaFWHMPoints=NaN(1,4);  
    signalFWHMPoints=NaN(1,4);
    FWHMIndices=NaN(1,4);
    for i=1:4
        [lambdaFWHMPoints(i),~]=ginput(1);
        signalFWHMPoints(i)=interp1(Lambda,Signal,lambdaFWHMPoints(i));
        [~,FWHMIndices(i)]=min(abs(lambdaFWHMPoints(i)-Lambda));
        plot(lambdaFWHMPoints,signalFWHMPoints,'ro')
    end
    
    lambdaFWHMPoints(1:2)=sort(lambdaFWHMPoints(1:2));
    lambdaFWHMPoints(3:4)=sort(lambdaFWHMPoints(3:4));

    %Guess input parameters, plot, and ask for user verification 
    
    %Center wavelength:
    Lambda_o=mean(lambdaFWHMPoints);
    Lambda_s =mean(lambdaFWHMPoints(1:2));
    [~,Lambda_s_Index] = min(abs(Lambda_s-Lambda));
    Lambda_a=mean(lambdaFWHMPoints(3:4));
    [~,Lambda_a_Index] = min(abs(Lambda_a-Lambda));
    
    %Splitting quality factor   
    Q_bs=Lambda_o/(Lambda_a-Lambda_s);
    
    %Loaded quality factors:
    Q_s =Lambda_o/(lambdaFWHMPoints(4)-lambdaFWHMPoints(3));
    Q_a=Lambda_o/(lambdaFWHMPoints(2)-lambdaFWHMPoints(1));
    
    %Resonance contrast:
    RC_s =1-Signal(Lambda_s_Index );
    RC_a=1-Signal(Lambda_a_Index);
    
    %External coupling quality factor
    Q_ex_s= 2*Q_s /(RC_s );
    Q_ex_a=2*Q_a/(RC_a);
    Q_ex=(Q_ex_s+Q_ex_a)/2; %(Assume the external coupling is equal)
    
    %Intrinsic quality factors  
    Q_s_i =Q_ex_s* Q_s /(Q_ex_s -Q_s);
    Q_a_i=Q_ex_a*Q_a/(Q_ex_a-Q_a);
    
    params(1)=Lambda_o;
    params(2)=Q_ex;
    params(3)=Q_s_i;
    params(4)=Q_a_i;
    params(5)=Q_bs;
    
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
        
end

