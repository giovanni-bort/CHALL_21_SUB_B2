function [BLD , RHO] =comp_bas_drift(ECG);
% compute base line drift with quadratic variation reduction [1]
%
% [1] Baseline wander removal for bioelectrical signals by quadratic variation reduction
%     A Fasano, V Villani, Signal Processing 2014, Vol. 99, pp. 48-57
%

n=numel(ECG);
LL=10000.0;
    I_SP=[];J_SP=[];S_SP=[];
    I_SP(1    :n-1  )=1:n-1 ; J_SP(1    :n-1  )= 1 :n-1; S_SP(1    :n-1  )=  +1  ;
    I_SP(n-1+1:2*n-2)=1:n-1 ; J_SP(n-1+1:2*n-2)= 2 :n  ; S_SP(n-1+1:2*n-2)= -1   ;
    DSP=sparse(I_SP,J_SP,S_SP);
    
  I_SP=[];J_SP=[];S_SP=[];
    % I_SP=[ 2:n-1 , 2:n-1   , 2:n-1  ,  1     ,    1    ,   n    ,  n   ] ;
    % J_SP=[ 2:n-1 , 2-1:n-2 , 2+1:n  ,  1     ,    2    ,   n    ,  n-1 ] ; 
    % S_SP=[2*LL+1 , -1*LL   ,  -1*LL , 1*LL+1 ,  -1*LL  , 1*LL+1 , -1*LL ]
    I_SP(1    :n-2  )=2:n-1; J_SP(1    :n-2  )= 2 :n-1; S_SP(1    :n-2  )=  2 * LL +1  ;
    I_SP(n-1  :2*n-4)=2:n-1; J_SP(n-1  :2*n-4)=2-1:n-2; S_SP(n-1  :2*n-4)= -1 * LL     ;
    I_SP(2*n-3:3*n-6)=2:n-1; J_SP(2*n-3:3*n-6)=2+1:n  ; S_SP(2*n-3:3*n-6)= -1 * LL     ;
    I_SP(3*n-5:3*n-5)=1    ; J_SP(3*n-5:3*n-5)=1      ; S_SP(3*n-5:3*n-5)=  1 * LL + 1 ;
    I_SP(3*n-4:3*n-4)=1    ; J_SP(3*n-4:3*n-4)=2      ; S_SP(3*n-4:3*n-4)= -1 * LL     ;
    I_SP(3*n-3:3*n-3)=n    ; J_SP(3*n-3:3*n-3)=n      ; S_SP(3*n-3:3*n-3)=  1 * LL + 1 ;
    I_SP(3*n-2:3*n-2)=n    ; J_SP(3*n-2:3*n-2)=n-1    ; S_SP(3*n-2:3*n-2)= -1 * LL     ;
    DDSP=sparse(I_SP,J_SP,S_SP);
     BLD=DDSP\ECG;
     RHO=norm(DSP*BLD);
end
