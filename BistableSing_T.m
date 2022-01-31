function [ T, paramNames] = BistableSing_T(params, Lambda, varargin)
%Numerically solves for thermally bistable modes
    

    %Expand parameter cell
    %params=moreparams{1};
    %ScanDirection=moreparams{2};

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
    Lambda_o=params(1);       %Center wavelength of resonance
    Q_ex=params(2);           %External (coupling) quality factor
    Q_i=params(3);            %Sym mode intrinsic quality factor
    a=params(4);              %Thermal drift coefficient
    %ScanDirection=params(4);  %Laser scanning direction
    
    %Apply scale factor
    
    %Detuning
    Detuning = Lambda_o-Lambda;
    
    %Calculate required Quality factors
    Q = Q_i*Q_ex/(Q_i+Q_ex);
    
    %Temperature change
    Delta_T = zeros(size(Lambda));
    Delta_T_alt = zeros(size(Lambda));
    
    %Solve steady state equation
    
    IK = (2*Q_ex)^2*((1/(2*Q))^2+a^2);
    
    %x = sym('x');
    
    %Define array of coefficients
    
    c0 = -IK*(1/(2*Q_ex))^2*ones(size(Lambda));
    c1 = (1/Lambda_o^2)*(Lambda-Lambda_o).^2+(1/(2*Q))^2;
    c2 = 2*a*(1-Lambda./Lambda_o);
    c3 = a^2*ones(size(Lambda));
    
    
    %figure
    for n=1:length(Lambda)
%         c0 = IK;
%         c1 = -4*Q^2/Lambda_o^2*(Lambda(n)-Lambda_o).^2-1;
%         c2 = -4*Q^2*a/Lambda_o*(Lambda_o-2*Lambda(n))-1;
%         c3 = -4*Q^2*a-1;

%         c0 = -IK*(1/(2*Q_ex))^2;
%         c1 = (1/Lambda_o^2)*(Lambda(n)-Lambda_o).^2+(1/(2*Q))^2;
%         c2 = 2*a*(1-Lambda(n)./Lambda_o);
%         c3 = a^2;

        SteadyState = @(x) c0(n)+c1(n).*x+c2(n).*(x.^2)+c3(n).*(x.^3);
    
        %Delta_T(n) = fzero(SteadyState, 0);
        
        if(n>1)
            Delta_T(n) = fzero(SteadyState, Delta_T(n-1));
        else
            if strcmp(ScanDirection,'Forward')
                Delta_T(n) = fzero(SteadyState, 0);
            elseif strcmp(ScanDirection,'Backward')
                Delta_T(n) = fzero(SteadyState, length(Delta_T));
            end
        end
        
%         if mod(n,100)==0
%             x_temp = linspace(-5,5,100);
%             plot(x_temp,SteadyState(x_temp),...
%                 Delta_T(n),SteadyState(Delta_T(n)),'ro');
%             xlabel('\DeltaT')
%             ylabel('f(\DeltaT)')
%             pause(1)
%         end    
            
    end
    
    Drift = 1+a*Delta_T;
    
    Pow=-1/(2*Q_ex)./...
        (-1/(2*Q)+1i*((Lambda-Lambda_o.*Drift)/Lambda_o));

    %Transmission
    T=abs(-1+Pow).^2;
        
    %IK
        
    %Output the parameter names
    S1='Center Wavelength [nm]  ';
    S2='Coupling Quality Factor ';
    S3='Intrinsic Quality Factor';
    S4='Scaled thermal shift    ';
    
%     figure
%     subplot(2,1,1)
%     plot(Lambda,Delta_T,Lambda,Delta_T_alt)
%     title('Delta T')
%     subplot(2,1,2)
%     plot(Lambda,T)
%     title('Bistable')
        
    paramNames=[S1;S2;S3;S4];
    paramNames=cellstr(paramNames);
    
end