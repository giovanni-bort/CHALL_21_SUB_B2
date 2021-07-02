%function define_DIAGN_star

% DIAGN_star  :   codice SNOMED DIAGN_star
% HDIAGN_satr : abbreviazione codice DIAGN_star
% IDIAGN_star_FIN: indice diagnosi usata 
% IDIAGN_star_ATT: indici diagnosi attive/usate

%    **************************** NON MODIFICARE ORDINE DIAGN_star ====> codici diagnosi per training CNN ************************     
%    **************************  (original in check_DIAGN_star_pro) ------------------------------------------------------------------
DIAGN_star=[270492004 	164889003 	164890007 	426627000 	713427006 	713426002 	445118002   39732003 	164909002 ...
            251146004 	698252002 	10370003 	284470004 	427172004  164947007 	111975006 	164917005 	47665007  ...
            59118001 	427393009 	426177001   426783006 	427084000 	63593006 	164934002 	59931005 	17338001 ...
            6374002    733534002   365413008  9999999 ];
HDIAGN_star ={ 'IAVB' ;   'AF'    ; 'AFL'     ;  'Brady'  ; 'CRBBB'    ; 'IRBBB'  ; 'LAnFB'   ; 'LAD'     ; 'LBBB' ; ...
               'LQRSV' ; 'NSIVCB' ; 'PR'      ;  'PAC'    ;  'PVC'     ;  'LPR'    ;  'LQT'   ; 'QaB'     ;  'RAD' ; ...
               'RBBB'  ;  'SA'    ; 'SB'      ; 'SNR'     ; 'STach'    ; 'SVPB'   ; 'TAb'     ; 'Tinv'    ; 'VPB' ; ...
               'BBB'   ;  'CLBBB' ; 'PRWP'    ; '*Other*' } ;
% % A: RBBB(19) = CRBB(5)
% % B: PAC(13)  = SVPB(24)
% % C: PVC(14)  = VEB(27)
% % D: LBBB(9)  = CLBBB(29) 
% %removed:      [             x                                                        x       x      x       ];   
% %              [             A           D           B  C              A              B       C      D       ];
% %              [ 1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 ];
IDIAGN_star_FIN= [ 1  2  3  4 19  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 13 25 26 14 28  9 30 31 ];

IDIAGN_star_ATT= [ 1  2  3  4     6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23    25 26    28    30 ];

% IA_fin= [ 1  2  3  4 19  6  7  8  9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 13 25 26 14 28  9 30 31 ];


%i_st=[1:4 6:23 25:26],