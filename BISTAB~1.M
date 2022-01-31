function[ params ] = BistableSing_T_Param_Guess( Lambda, Signal, varargin )
    
    
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
    
    %Minimum signal index
    [~,Signal_Min_Index] = min(Signal);

    %Shifted center wavelength
    Lambda_c = Lambda(Signal_Min_Index);
    
    %Thermal drift coefficient
    a = (Lambda_c-Lambda_o)./Lambda_o;
    
    %Loaded quality factors:
    Q_t =Lambda_c/(lambdaFWHMPoints(2)-lambdaFWHMPoints(1));
    
    %Resonance contrast:
    RC =1-Signal(Signal_Min_Index );
    
    %External coupling quality factor
    Q_ex= 2*Q_t /(RC);
    
    %Intrinsic quality factors  
    Q_i = Q_ex* Q_t /(Q_ex-Q_t);
    
    %Check scanning direction
    ScanDirection = questdlg('Choose scan direction:', ...
        '',...
        'Forward','Backward','Forward');
    
    params(1)=Lambda_o;
    params(2)=Q_ex;
    params(3)=Q_i;
    params(4)=a;
    
    %={params,ScanDirection};
    
    %This should be modified to handle the reflection case
    %Tfit=BistableSing_T(params, Lambda, ScanDirection, 1);
    Tfit=BistableSing_T(params, Lambda);
    %Tfit=BistableSing_T_new(params, Lambda);
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
