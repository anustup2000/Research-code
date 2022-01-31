function [ params ] = Singlet_T_Param_Guess( Lambda, Signal, varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
        
    %Make plot and request input
    fig=figure();
    plot(Lambda,Signal)
    title('Please click the FWHM of the resonance')
    xlabel('\lambda [nm]')
    ylabel('T')

    hold on
    lambdaFWHMPoints=NaN(1,2);  
    signalFWHMPoints=NaN(1,2);
    FWHMIndices=NaN(1,4);
    for i=1:2
        [lambdaFWHMPoints(i),~]=ginput(1);
        signalFWHMPoints(i)=interp1(Lambda,Signal,lambdaFWHMPoints(i));
        [~,FWHMIndices(i)]=min(abs(lambdaFWHMPoints(i)-Lambda));
        plot(lambdaFWHMPoints,signalFWHMPoints,'ro')
    end
    
    lambdaFWHMPoints(1:2)=sort(lambdaFWHMPoints(1:2));
  
    %Guess input parameters, plot, and ask for user verification 
    
    %Center wavelength:
    Lambda_o=mean(lambdaFWHMPoints);
    [~,Lambda_o_Index] = min(abs(Lambda_o-Lambda));

    
    %Loaded quality factors:
    Q_t =Lambda_o/(lambdaFWHMPoints(2)-lambdaFWHMPoints(1));
    
    %Resonance contrast:
    RC =1-Signal(Lambda_o_Index );
    
    %External coupling quality factor
    Q_ex= 2*Q_t /(RC);
    
    %Intrinsic quality factors  
    Q_i = Q_ex* Q_t /(Q_ex-Q_t);
    
    params(1)=Lambda_o;
    params(2)=Q_ex;
    params(3)=Q_i;
    
    %This should be modified to handle the reflection case
    Tfit=Singlet_T(params, Lambda, 1);
    hold off
    plot(Lambda,Signal,Lambda,Tfit)
    xlabel('\lambda [nm]')
    ylabel('T')
      
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

