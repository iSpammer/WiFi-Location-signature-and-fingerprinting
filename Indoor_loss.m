function PL=Indoor_loss(d,d0,N_Partition)

% This function calculates the propagation loss for a path with length d
% which has
% path loss exponent n=3
% close-in reference distance d0
% carrier frequency fc=2.4 GHz, so the wavlength=12.5 cm = 0.125 m
% PAF = 3 dB
% Tx and Rx Gains = 1 = 0dB

PL_d0=20*log10(4*pi*d0/0.125);  % PL(d0)=20*log10(4*pi*d0/lambda)+Gtx+Grx
PL=PL_d0+10*3*log10(d/d0)+3*N_Partition;    % The path loss in dB
