function [ T_interp, paramNames ] = Filter_T(params, Lambda, varagin)
%Doublet Summary of this function goes here
%   Detailed explanation goes here

    %Find if scale factor included
    if nargin == 3
        scaleVec=varagin;
    else
        scaleVec=ones(1,length(params));
    end 
    
    % Apply scale factor    
    params=params.*scaleVec;

    % Create filter function
    Lambda_f=params(1); %Center wavelength of resonance

    load('Filter100GHzData')
    
    W=W+Lambda_f;
    
    T_interp = interp1(W,T,Lambda,'linear','extrap');
    
      
   paramNames=['Filter Wavelength'];


end

