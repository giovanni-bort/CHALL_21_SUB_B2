function [IA,IB,IC]= check_DIAGN_star_pro(diagn_to_chk,OPT_PRN)
%
% IA : nuovo numero diagnosi tra 1:28    (28=other)
% IB : abbreviazioni diagnosi star
% IC : codici SNOMED diagnosi star
%

%    **************************** NON MODIFICARE ORDINE DIAGN_star ====> codici diagnosi per training CNN ************************     
%    **************************  (original in check_diagn_star) ------------------------------------------------------------------
% DIAGN_star=[270492004 	164889003 	164890007 	426627000 	713427006 	713426002 	445118002   39732003 	164909002 ...
%             251146004 	698252002 	10370003 	284470004 	427172004  164947007 	111975006 	164917005 	47665007  ...
%             59118001 	427393009 	426177001   426783006 	427084000 	63593006 	164934002 	59931005 	17338001 ...
%             6374002    733534002   365413008  9999999 ];
% HDIAGN_star ={ 'IAVB' ;   'AF'    ; 'AFL'     ;  'Brady'  ; 'CRBBB'    ; 'IRBBB'  ; 'LAnFB'   ; 'LAD'     ; 'LBBB' ; ...
%                'LQRSV' ; 'NSIVCB' ; 'PR'      ;  'PAC'    ;  'PVC'     ;  'LPR'    ;  'LQT'   ; 'QaB'     ;  'RAD' ; ...
%                'RBBB'  ;  'SA'    ; 'SB'      ; 'SNR'     ; 'STach'    ; 'SVPB'   ; 'TAb'     ; 'Tinv'    ; 'VPB' ; ...
%                'BBB'   ;  'CLBBB' ; 'PRWP'    ; '*Other*' } ;
% 
if(nargin<2),OPT_PRN=1;end
% A: RBBB(19) = CRBB(5)
% B: PAC(13)  = SVPB(24)
% C: PVC(14)  = VEB(27)
% D: LBBB(9)  = CLBBB(29) 
%removed:             x                                                        x       x      x     
%                     A           D           B  C              A              B       C      D   
%       [ 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 ];
% IA_fin= [ 1  2  3  4 19  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 13 25 26 14 28  9 30 31 ];
define_DIAGN_star;
IA_fin=IDIAGN_star_FIN;

 A=diagn_to_chk;B=0;
 if(ischar(A{1}))
     for i=1:numel(A), B(i)=str2double(A{i});end
 else
     for i=1:numel(A), B(i)=(A{i});end
 end
 
[C,IA]=intersect(DIAGN_star,B);
if(numel(C)==0), IA=numel(DIAGN_star);C=DIAGN_star(IA);  end
if(OPT_PRN>0),fprintf(': ');fprintf('%3.0f',IA); end
dia_changed=find(abs(IA_fin-(1:numel(IA_fin)))>0);
if(numel(  intersect(IA, dia_changed)  )>0)
    IA=IA_fin(IA)';
    if(OPT_PRN>0),fprintf(' [');fprintf('%3.0f',IA); fprintf(']');fprintf(' ==> ');end
else
if(OPT_PRN>0),fprintf(' --> ');end
end
IA=IA_fin(IA);
IB=DIAGN_star(IA);
IC=HDIAGN_star(IA);
if(OPT_PRN>0),
   fprintf('%10.0f ',C);
   fprintf(' %s ',HDIAGN_star{IA});
   fprintf('\n');
end

end
