%function valuta_Leads_Trained_NN_21   (final phase)
% 
% valuta un file_IMG  del paziente   con una trained_NN contenuta in  model.net
%
% Parametri pasati: H_Fs
%
NN_Leads=Max_leads;
fprintf('H_Fs:%6.0f   NN_Leads:%3.0f\n',H_Fs,NN_Leads);
%---------------------------------------------------------------------------

if(NN_Leads==2)          % two_leads    = [{'I'}, {'II'}];
   ECG_TMP=ECG_col(:,[1 2] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end
if(NN_Leads==3)         % three_leads  = [{'I'}, {'II'}, {'V2'}];
   ECG_TMP=ECG_col(:,[1 2  8] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end
if(NN_Leads==4)         % four_leads   = [{'I'}, {'II'}, {'III'}, {'V2'}];
   ECG_TMP=ECG_col(:,[1 2 3  8] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end
if(NN_Leads==6)         % six_leads    = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}];
   ECG_TMP=ECG_col(:,[1 2 3 4 5 6] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end
if(NN_Leads==12)         % all 12 leads
   ECG_TMP=ECG_col(:,[1:12] );
   fprintf('size leads(%2.0f):',NN_Leads);fprintf('%6.0f%6.0f',size(ECG_TMP));fprintf('\n');
end

if(size(ECG_TMP,1)<5000), ECG_TMP(5000,1)=0;end
ECG_PRO=ECG_TMP;

fprintf('--- %3.0f Leads - ECG: %4.0f%6.0f samples\n',NN_Leads, size(ECG_PRO));
ECG_CINC.dati=[ECG_PRO(:)' ];                % ********** ECG_data  ***********
%  ECG_CINC.diagn=STRUCT(num_file).diagn;
%  ECG_CINC.ind_diagn=STRUCT(num_file).ind_diagn;
ECG_CINC.Fs=Hz;
% [ind_dia_star,TEMP2,TEMP3]=check_DIAGN_star_pro(STRUCT(num_file).diagn);

 %----------------- OPT_IMG=1  --------------------------------------------
if(OPT_IMG_F==1),
   
    data=ECG_CINC.dati(:);
    Fs=ECG_CINC.Fs;
    [~,signalLength] = size(data);
    signalLength = numel(data);
    fprintf(' -> %6.0f samples %6.0f%6.0f ',signalLength,size(ECG_CINC.dati));
    fb = cwtfilterbank('SignalLength',signalLength, 'SamplingFrequency',Fs,'VoicesPerOctave',12);
    cfs = abs(fb.wt(data));
    im_ECG = ind2rgb(im2uint8(rescale(cfs)),jet(128));
    
end

%------------------------- OPT_IMG = 2 ------------------------------------
if(OPT_IMG_F==2),

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
 end
 
 fprintf('size ECG2:%6.0f%6.0f   leads_ok:%4.0f\n',size(ECG2),leads_ok);

%  ECG2=ECGfull(:,[7 8 9 10 11 12 5 1 2 6 3 4]);
NN=size(ECG2,1);
K_pass_sample=2; K_pass_leads=0.1;     % **** PARAMETRI K_pass_samples , K_pass_leads

EXTRM='nearest';
  [IM_X1 , IM_Y1]= ndgrid(1:NN, 1:leads_ok);
  IM_Z1 = ECG2(1:NN,:);
  F_F = griddedInterpolant(IM_X1,IM_Y1,IM_Z1);
  F_F.Method='linear';
  F_F.ExtrapolationMethod=EXTRM;
  [IM_XM,IM_YM]=ndgrid(1:K_pass_sample:NN,0.5:K_pass_leads:leads_ok+0.5);
  View_ECG_im=F_F(IM_XM,IM_YM)';  

  k_jet=256;

 im_ECG = ind2rgb(im2uint8(rescale(View_ECG_im)),jet(k_jet)); %(128));
 
 end  % ------------- IF opt_IMG_F=2   ------------------------------------

opt_QUAL=75;
    IMG_full_file=fullfile(pwd,'NEW_IMAGE.jpg');
    imwrite(imresize(im_ECG,[224 224]),IMG_full_file,'quality',opt_QUAL);

    ECG_image=imread(IMG_full_file);
    
    fprintf('Image FMT:%2.0f- size:',OPT_IMG_F);fprintf('%6.0f',size(ECG_image));
    fprintf(' sum:%10.0f%10.0f%10.0f \n',sum(sum(ECG_image)));
  
    [YPred,probs] = classify(model.net,ECG_image);
    iii=find(probs>0.04);
    if(numel(iii)<1),[iitmp,iii]=max(probs);end            % max of NN
 %   if(numel(iii)<1), iii=find(out_labels>0);end            % out_label of "do"
    my_label=[];  my_label(1:numel(probs))=0;
    my_label(iii)=1;
    
    my_scores=probs;
    
    fprintf('---Ypred');fprintf('%6.0f',YPred);fprintf('\n');
    fprintf('---score');fprintf('%6.3f',probs);fprintf('\n');



   