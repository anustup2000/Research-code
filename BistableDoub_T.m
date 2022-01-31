function [ T, paramNames ] = BistableDoub_T(params, Lambda, varargin)
%Doublet Summary of this function goes here
%   Detailed explanation goes here

    %Find if scale factor included
    ScanDirection = 'Forward';
    if nargin == 3
        scaleVec=varargin{1};
    elseif nargin == 4
        ScanDirection = varargin{2};
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
    a=params(6);        %Thermal drift coefficient
 
    %Apply scale factor
    
    %Detuning=(Lambda-Lambda_o)*scaleFactor;
    %Detuning=(Lambda-Lambda_o);
    
    %Calculate required Quality factors
    Q_s=Q_s_i*Q_ex/(Q_s_i+Q_ex);
    Q_a=Q_a_i*Q_ex/(Q_a_i+Q_ex);

    %Define delta t
    Delta_T = zeros(size(Lambda));
    
    %IK parameter
    IK = (2*Q_ex)^2*(1/(4*Q_s*Q_a)^2+1/(2*Q_bs)^2*(1/(2*Q_s)^2+1/(2*Q_a)^2+1/(2*Q_bs)^2) ...
         -a/Q_bs*(1/(2*Q_a)^2-1/(2*Q_s)^2)+a^2*(1/(2*Q_s)^2+1/(2*Q_a)^2-2/(2*Q_bs)^2) ...
         +8*a^3+a^4)/(1/(2*Q_s)^2+1/(2*Q_a)^2+2/(2*Q_bs)^2+4*a+2*a^2);
    
    %Simplifying terms for equation
    Lambda_p = (Lambda+Lambda_o)./Lambda_o;
    Lambda_m = (Lambda-Lambda_o)./Lambda_o;
    
    %Coefficients
    c0 = -IK*(1/2*Q_ex)^2*(1/(2*Q_s)^2+1/(2*Q_a)^2+2/(2*Q_bs)^2+2.*Lambda_m.^2);
    
    c1 = 1/(4*Q_s*Q_a)^2+1/(2*Q_bs)^2*(1/(2*Q_s)^2+1/(2*Q_a)^2+1/(2*Q_bs)^2) ...
         +1/Q_bs*(1/(2*Q_a)^2-1/(2*Q_s)^2).*Lambda_m+(1/(2*Q_s)^2+1/(2*Q_a)^2-2/(2*Q_bs)^2).*Lambda_m.^2 ...
         +Lambda_m.^4-IK*a/(2*Q_ex)^2*2.*Lambda_p;
    
    c2 = -a/Q_bs*(1/(2*Q_a)^2-1/(2*Q_s)^2)+(1/(2*Q_s)^2+1/(2*Q_a)^2-2/(2*Q_bs)^2) ...
         *-2*a.*Lambda_m-4*a.*Lambda_m-IK*2*a^2/(2*Q_ex)^2;
    
    c3 = (1/(2*Q_s)^2+1/(2*Q_a)^2-2/(2*Q_bs)^2)*a^2+6*a^2.*Lambda_m.^2;
    
    c4 = 4*a^3.*Lambda_p;
    
    c5 = a^4.*ones(size(Lambda));
    
    %Solve equation
    
    for n=1:length(Lambda)
        
        SteadyState = @(x) c0(n)+c1(n).*x+c2(n).*(x.^2)+c3(n).*(x.^3)+c4(n).*(x.^4)+c5(n).*(x.^5);
        
        if(n>1)
            Delta_T(n) = fzero(SteadyState, Delta_T(n-1));
        else
            if strcmp(ScanDirection,'Forward')
                Delta_T(n) = fzero(SteadyState, 0);
            elseif strcmp(ScanDirection,'Backward')
                Delta_T(n) = fzero(SteadyState, length(Delta_T));
            end
        end
        
    end
    
    Drift=1+a.*Delta_T;
    
    %Clockwise mode
    Pow_s=-1/(2*Q_ex)./...
        (-1/(2*Q_s)+1i*((Lambda-Lambda_o.*Drift)/Lambda_o+1/(2*Q_bs)));

    %Counterclockwise
    Pow_a=-1/(2*Q_ex)./...
        (-1/(2*Q_a)+1i*((Lambda-Lambda_o.*Drift)/Lambda_o-1/(2*Q_bs)));

    %Transmission
    T=abs(-1+Pow_s+Pow_a).^2;
    
    %Output the parameter names
    S1='Center Wavelength [nm]                     ';
    S2='Coupling Quality Factor                    ';
    S3='Symmetric Mode Intrinsic Quality Factor    ';
    S4='Antisymmetric Mode Intrinsic Quality Factor';
    S5='Backscattering Quality Factor              ';
    S6='Scaled Thermal Drift                       ';
    
    paramNames=[S1;S2;S3;S4;S5;S6];
    paramNames=cellstr(paramNames);
    
end

