% function new_ECG_preproc_21
% 
% parametri da passare: H_Fs
%                       ECG
%================================== INI program of preprocessing ===============================================    
Freq=H_Fs;
ECG_col=ECG';
if(Freq==500),fprintf(' - - - frequency:500Hz   size(ECG)=%3.0f%6.0f\n',size(ECG_col));
else
    fprintf('Frequency:%6.0f\n',Freq);
    ECG_col=Interpolation(ECG_col,Freq,500);
    %ECG=ECG';
   fprintf('freq:%6.0f  -> resampled at 500Hz   size ECG:%4.0f%8.0f\n', Freq,size(ECG))

end
   Hz=500;
%        tttemp=Interpolation(ECG',Freq,500);

%Prova_tools
%     Zero_Leads=sum((ECG),2)==0;
%     fprintf(' Zero_leads:');fprintf('%2.0f',Zero_Leads);fprintf('%1.0f',Zero_Leads); fprintf('\n');
%     Zero_Leads=sum(abs(ECG),2)==0;
%     fprintf(' Zero_leads:');fprintf('%2.0f',Zero_Leads);fprintf('%1.0f',Zero_Leads); fprintf('\n');
    ECG_col=ECG_col/1000;
    
%     Zero_Leads=sum(ECG,2)==0;
%     fprintf(' Zero_leads:');fprintf('%2.0f',Zero_Leads);fprintf('%1.0f',Zero_Leads); fprintf('\n');
    
     if(size(ECG_col,1)>4999)
         ECG_new=ECG_col(1:5000,:);
     else
         ECG_new=ECG_col; ECG_new(5000,:)=0;
     end
     fprintf('MIN:%10.4f MAX:%10.4f  ',min(ECG_new(:)),max(ECG_new(:)));
     ECG_col=ECG_new;    % ECG_col -> (samples, leads)
     fprintf('baseline_drift:');DRIFT=ECG_col*0;
    for ii_Lds=1:size(ECG_col,2)
         DRIFT(:,ii_Lds)=comp_bas_drift(ECG_col(:,ii_Lds));
         fprintf('%3.0f',ii_Lds);
    end
    ECG_col=ECG_col-DRIFT;
    fprintf('  size ECG_col:%6.0f%6.0f\n',size(ECG_col));
    
    
     a=1; b=[]; b(1:10)=1/10; 
   ECG_filtered=filter(b,a,ECG_col);  %fprintf('----- size ECG_filtered:%6.0f%6.0f\n',size(ECG_filtered));
     
    % ECG=ECG_filtered';
     ECG_col=ECG_filtered;
     ECG_col=min(ECG_col,2);
     ECG_col=max(-2,ECG_col);
     
     fprintf(' ECG_filtered: %2.0f %6.0f  ECG_col:%4.0f%6.0f  min:%10.4f max:%10.4f\n',size(ECG_filtered),size(ECG_col),min(ECG_col(:)),max(ECG_col(:)));
     fprintf('SUM_ecg:');fprintf('%10.0f',sum(abs(ECG_col),1));fprintf('\n');

%======================================================================
