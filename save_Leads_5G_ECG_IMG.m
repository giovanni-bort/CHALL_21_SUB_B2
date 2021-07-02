 %function save_Leads_5G_ECG_IMG (final phase)

%  OPT_IMG_F option    contained in start_Global_Parameters
%
% salva un file IMG  per paziente in CINC20_ECG_IMG1
% nome file: ECG_Xnnnn_ddd.mat   X:AQISHE    nnnn: 0001    ddd:0167  diagnosi(es. 01+67)
%
%
% % twelve_leads = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}, {'V1'}, {'V2'}, {'V3'}, {'V4'}, {'V5'}, {'V6'}];
% % six_leads    = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}];
% % four_leads   = [{'I'}, {'II'}, {'III'}, {'V2'}];
% % three_leads  = [{'I'}, {'II'}, {'V2'}];
% % two_leads    = [{'I'}, {'II'}];
%
% % %        aVR=(-I - II)/2;     % AVR_mean=(-I_mean -  II_mean)/2;
% % %        aVL=( I - III)/2;    % AVL_mean=( I_mean - III_mean)/2;
% % %        aVF=(II + III)/2;    % AVF_mean=(II_mean + III_mean)/2;
       
if(NN_Leads==2)          % two_leads    = [{'I'}, {'II'}];
   Ini_File='ECG_02L_';
   ECG_TMP=ECG_col(:,[1 2] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end
if(NN_Leads==3)         % three_leads  = [{'I'}, {'II'}, {'V2'}];
   Ini_File='ECG_03L_';
   ECG_TMP=ECG_col(:,[1 2  8] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end

if(NN_Leads==4)         % four_leads   = [{'I'}, {'II'}, {'III'}, {'V2'}];
   Ini_File='ECG_04L_';
   ECG_TMP=ECG_col(:,[1 2 3  8] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end

if(NN_Leads==6)         % six_leads    = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}];
   Ini_File='ECG_06L_';
   ECG_TMP=ECG_col(:,[1 2 3 4 5 6] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end
if(NN_Leads==12)         % all 12 leads
   Ini_File='ECG_12L_';
   ECG_TMP=ECG_col(:,[1:12] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end

% ECG_mean=[ I_mean II_mean III_mean V1_mean V2_mean V3_mean V4_mean V5_mean V6_mean ];
% ECG_TMP=[ I;II;III; V1; V2; V3; V4; V5; V6];

if(size(ECG_TMP,1)<5000), ECG_TMP(5000,1)=0;end
ECG_PRO=ECG_TMP;

fprintf('--- %3.0f Leads - ECG: %4.0f%6.0f samples\n',NN_Leads, size(ECG_PRO));
ECG_CINC.dati=[ECG_PRO(:)' ];                % ********** ECG_data  ***********
 ECG_CINC.diagn=STRUCT(num_file).diagn;
 ECG_CINC.ind_diagn=STRUCT(num_file).ind_diagn;
ECG_CINC.Fs=Hz;
[ind_dia_star,TEMP2,TEMP3]=check_DIAGN_star_pro(STRUCT(num_file).diagn);

% ---- Check file in lisk_OK -------------
[KNEW_NAME,K_TYPE,K_NUM]=extract_info_from_name(H_recording);
Hrec_chk=[file_key,num2str(K_NUM,'%05.0f')];
fprintf(' **Hrecording: %s  -- ',Hrec_chk);
[is_16K,loc_16K]=ismember(Hrec_chk,List_16K);
if(is_16K>0),fprintf(' is present: %s   **** SAVE IMG2 **  opt_IMG_F:%2.0f\n',List_16K{loc_16K},OPT_IMG_F);
else
    fprintf(' *** not present in 16K ****\n');
end


if(ne(K_NUM,num_file)),fprintf('***** DIVERSI***');end
fprintf('NEW:%s  K_NUM=%6.0f  num_file:%6.0f  type: %s  %s \n',KNEW_NAME,K_NUM,num_file,K_TYPE,file_key);
% fprintf('size DIA_*:%6.0f%6.0f\n',size(ind_dia_star));

file_00X=fullfile([Ini_File,file_key,num2str(K_NUM,'%05.0f_'),num2str(ind_dia_star,'%02.0f') ]);

 %----------------- OPT_IMG=1  --------------------------------------------
if(OPT_IMG_F==1),

    imgLoc =ECG_DL_directory; % IMR1: Image RAW ECG 1
   
   if ~exist(imgLoc, 'dir')
        mkdir(imgLoc)
   end
   
   fprintf('Save ECG images in : %s (Wavelet scalogram)\n',imgLoc);
    data=ECG_CINC.dati(:);
    Fs=ECG_CINC.Fs;
    [~,signalLength] = size(data);
    signalLength = numel(data);
    fprintf(' -> %6.0f samples %6.0f%6.0f ',signalLength,size(ECG_CINC.dati));
    fb = cwtfilterbank('SignalLength',signalLength, 'SamplingFrequency',Fs,'VoicesPerOctave',12);

    cfs = abs(fb.wt(data));
    im = ind2rgb(im2uint8(rescale(cfs)),jet(128));
    

    opt_QUAL=75;
    imFileName = [file_00X '.jpg'];
    imwrite(imresize(im,[224 224]),fullfile(imgLoc,imFileName),'quality',opt_QUAL);
    fprintf('IMG:   %s ',imFileName); fprintf(' %s ',ECG_CINC.diagn{:}); fprintf(' %3.0f ',ECG_CINC.ind_diagn); fprintf('\n');

end


%------------------------- OPT_IMG = 2 ------------------------------------
%----------------- OPT_IMG=2  --------------------------------------------
if(OPT_IMG_F==2),
   %imgLoc ='ECG_DL_CINC20_IMG_2';
%    imgLoc ='CINC20_ECG_IMG2_OK';
   imgLoc =ECG_DL_directory; % IMR1: Image RAW ECG 1
   if ~exist(imgLoc, 'dir')
        mkdir(imgLoc)
   end
   fprintf('Save ECG images in : %s  (leads images)\n',imgLoc);


   T_1=toc;

      %---------- extract ECG data and create ECGfull-----------------
 BBB=ECG_CINC.dati;
 fprintf('****size BBB:%6.0f%6.0f\n',size(BBB));
 leads_ok=size(ECG_TMP,2);
 %ECG_TMPOK=ECG_TMP(:,1:5000);
 fprintf('size ECG_TMP:%6.0f%6.0f  NN_leads=%4.0f  leads_ok=%4.0f\n',size(ECG_TMP),NN_Leads,leads_ok);
 
ECG_L=ECG_TMP;
 if(NN_Leads==2)
     ECG2=ECG_L;
 end
  if(NN_Leads==3)
     ECG2=ECG_L(:,[3 1 2 ]);
 end
  if(NN_Leads==4)
     ECG2=ECG_L(:,[4 1 2  3 ]);
 end
 
 if(NN_Leads==6)
     ECG2=ECG_L(:,[ 5 1 4 2 6 3 ]);  ECG2(:,3)=-ECG2(:,3) ;   % aVL, I, -aVR, II, aVF, III
 end
  if(NN_Leads==12)
     ECG2=ECG_L(:,[7 8 9 10 11 12 5 1 4 2 6 3 ]); ECG2(:,9)=-ECG2(:,9) ; % V1:V6, aVL, I, -aVR, II, aVF, III
%      save ECG2_12 'ECG2' 
 end
 
 fprintf('size ECG2:%6.0f%6.0f   leads_ok:%4.0f\n',size(ECG2),leads_ok);


 
%  ECG2=ECGfull(:,[7 8 9 10 11 12 5 1 2 6 3 4]);
T_1b=toc;
NN=size(ECG2,1);
K_pass_sample=2; K_pass_leads=0.1;     % **** PARAMETRI K_pass_samples , K_pass_leads

% % % %--------------------------------------
  EXTRM='nearest';
  [IM_X1 , IM_Y1]= ndgrid(1:NN, 1:leads_ok);
  IM_Z1 = ECG2(1:NN,:);
  F_F = griddedInterpolant(IM_X1,IM_Y1,IM_Z1);
  F_F.Method='linear';
  F_F.ExtrapolationMethod=EXTRM;
  [IM_XM,IM_YM]=ndgrid(1:K_pass_sample:NN,0.5:K_pass_leads:leads_ok+0.5);
  View_ECG_im=F_F(IM_XM,IM_YM)';  

%IM3=imagesc(VVq);
 k_jet=256;
%  im = ind2rgb(im2uint8(rescale(IM3.CData)),jet(k_jet)); %(128));
 im = ind2rgb(im2uint8(rescale(View_ECG_im)),jet(k_jet)); %(128));
% % %  imwrite(imresize(im,[224 224]),'NEWIMAGE2.jpg');
T_6b=toc;
 
 opt_QUAL=75;
    imFileName = [file_00X '.jpg'];
     imwrite(imresize(im,[224 224]),fullfile(imgLoc,imFileName),'quality',opt_QUAL);
    fprintf('IMG2:   %s ',imFileName); fprintf(' %s ',ECG_CINC.diagn{:}); fprintf(' %3.0f ',ECG_CINC.ind_diagn); fprintf('\n');
  
T_2=toc;
%fprintf(' t:%8.1f  mean:%8.1f',T_2-T_1,T_2/(ii-K_ini+1))
     fprintf(' ---elapsed time: %10.2f',T_2-T_1b);
     fprintf(' -->');
%      fprintf('%10.3f',T_2b-T_1b,T_3b-T_2b,T_4b-T_3b,T_5b-T_4b,T_6b-T_5b,T_2-T_6b);
     fprintf('\n');
   
 end  % ---- IF opt_IMG_F=2   


   