function [ T, paramNames ] = Doublet_T(params, Lambda, varagin)
%Doublet Summary of this function goes here
%   Detailed explanation goes here

    %Find if scale factor included
    if nargin == 3
        scaleVec=varagin;
    else
        scaleVec=ones(1,length(params));
    end 
    
    %scaleFactor
    
    params=params.*scaleVec;
    
    %Organize the fitting parameters
    Lambda_o=params(1); %Center wavelength of resonance
    Q_ex=params(2);     %External (coupling) quality factor
    Q_s_i=params(3);    %Sym mode intrinsic quality factor
    Q_a_i=params(4);    %Antisym mode intrinsic quality factor
    Q_bs=params(5);     %Backscattering quality factor
 
    %Apply scale factor
    
    %Detuning=(Lambda-Lambda_o)*scaleFactor;
    Detuning=(Lambda-Lambda_o);
    
    %Calculate required Quality factors
    Q_s=Q_s_i*Q_ex /(Q_s_i  +Q_ex);
    Q_a=Q_a_i*Q_ex/(Q_a_i+Q_ex);

    %Clockwise mode
    Pow_s=-1/(2*Q_ex)./...
        (-1/(2*Q_s)+1i*(Detuning/Lambda_o+1/(2*Q_bs)));

    %Counterclockwise
    Pow_a=-1/(2*Q_ex)./...
        (-1/(2*Q_a)+1i*(Detuning/Lambda_o-1/(2*Q_bs)));

    %Transmission
    T=abs(-1+Pow_s+Pow_a).^2;
    
    %Output the parameter names
    S1='Center Wavelength [nm]                     ';
    S2='Coupling Quality Factor                    ';
    S3='Symmetric Mode Intrinsic Quality Factor    ';
    S4='Antisymmetric Mode Intrinsic Quality Factor';
    S5='Backscattering Quality Factor              ';
    
    paramNames=[S1;S2;S3;S4;S5];
    paramNames=cellstr(paramNames);
    
end

