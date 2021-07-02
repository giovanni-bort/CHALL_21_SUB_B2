function  model = team_training_code(input_directory,output_directory,K_ini,K_end,K_TRAIN)  
% train_ECG_leads_classifier  *** in: \Subm_B1\***

if(nargin<3),K_ini=0;end
if(nargin<4),K_end=0;end
if(nargin<5),K_TRAIN=0;end

start_Global_Parameters;   %***********
% 
% Purpose: Train ECG leads and obtain classifier models
% for 12-lead, 6-lead, 3-lead, 4-lead and 2-lead ECG sets
% Inputs:    1. input_directory
%            2. output_directory
% Outputs:  model: trained model
% %--------------
% Define lead sets (e.g 12, 6, 4, 3 and 2 lead ECG sets)
twelve_leads = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}, {'V1'}, {'V2'}, {'V3'}, {'V4'}, {'V5'}, {'V6'}];
six_leads    = [{'I'}, {'II'}, {'III'}, {'aVR'}, {'aVL'}, {'aVF'}];
four_leads   = [{'I'}, {'II'}, {'III'}, {'V2'}];
three_leads  = [{'I'}, {'II'}, {'V2'}];
two_leads    = [{'I'}, {'II'}];
lead_sets = {twelve_leads, six_leads, four_leads, three_leads, two_leads};

disp('Loading data...')

% Find files.
input_files = {};
features =[];
for f = dir(input_directory)'
    if exist(fullfile(input_directory, f.name), 'file') == 2 && f.name(1) ~= '.' && all(f.name(end - 2 : end) == 'mat')
        input_files{end + 1} = f.name;
    end
end

% Extract classes from dataset.
% read number of unique classes
% % % classes = get_classes(input_directory,input_files);
 [classes,STRUCT2] = get_classes_MY(input_directory,input_files);

num_classes = length(classes);     % number of classes
num_files   = length(input_files);
Total_data  = cell(1,num_files);
Total_header= cell(1,num_files);

   for ii=1:numel(STRUCT2)
        [~,ind_diagn]=ismember(STRUCT2(ii).diagn,classes);
        STRUCT2(ii).ind_diagn=ind_diagn;
   end
%     load('List_8320.mat');
%     load('List_4160.mat');
%     load('List_16K.mat');
    load('List21_13K.mat');
    List_16K=List21_13K;
STRUCT=STRUCT2;

% % Load data recordings and header files
% Iterate over files.
disp('Training model..')

label=zeros(num_files,num_classes);

K_ini_files=1;
K_end_files=num_files;
if(K_ini>0),K_ini_files=K_ini;end
if((K_end>0)&(K_end<num_files)),K_end_files=K_end; end


for i =K_ini_files:K_end_files
    TTT1=(['    ', num2str(i), '/', num2str(num_files), '...']);
    fprintf('%s',TTT1);
    % Load data.
    file_tmp = strsplit(input_files{i},'.');
    tmp_input_file = fullfile(input_directory, file_tmp{1});
    [data,header_data] = load_challenge_data(tmp_input_file);
    % % Check the number of available ECG leads
    tmp_hea = strsplit(header_data{1},' ');
    num_leads = str2num(tmp_hea{2});
    [leads, leads_idx] = get_leads(header_data,num_leads);
    model=0;
    file_key=input_files{i}(1:1);   % old:  file_key='A';
    examine_ECG_save_IMG(data,header_data,model,STRUCT,output_directory,i,file_key,List_16K,OPT_IMG_F);
end  % loop sul numero di files

if(K_TRAIN==0),
% % train logistic regression models for the lead sets
for i=1:length(lead_sets)
    % Train ECG model
    disp(['Training ',num2str(length(lead_sets{i})),'-lead ECG model...'])
    num_leads = length(lead_sets{i});
    [leads, leads_idx] = get_leads(header_data,num_leads);
    % Features = [1:12] features from 12 ECG leads + Age + Sex
    
    %num_leads = 12;
    opt_CHALL_leads=num_leads;
    driver_train_CNN_leads
    model=[];
    model.net=NET_tot.CNN(1).net;model.num_leads=num_leads;    
    save_ECGleads_model(model,output_directory,classes,num_leads);
end
end
end

function save_ECGleads_model(model,output_directory,classes,num_leads) %save_ECG_model
% Save results.
tmp_file = [num2str(num_leads),'_lead_ecg_model.mat'];
filename = fullfile(output_directory,tmp_file);
save(filename,'model','classes','-v7.3');

disp('Done.')
end

function save_ECGleads_features(features,output_directory) %save_ECG_model
% Save results.
tmp_file = 'features.mat';
filename=fullfile(output_directory,tmp_file);
save(filename,'features');
end

% find unique number of classes
function classes = get_classes(input_directory,files)
classes={};
num_files = length(files);
k=1;
for i = 1:num_files
    g = strrep(files{i},'.mat','.hea');
    input_file = fullfile(input_directory, g);
    fid=fopen(input_file);
    tline = fgetl(fid);
    tlines = cell(0,1);
    while ischar(tline)
        tlines{end+1,1} = tline;
        tline = fgetl(fid);
        if startsWith(tline,'#Dx')
            tmp = strsplit(tline,': ');
            tmp_c = strsplit(tmp{2},',');
            for j=1:length(tmp_c)
                idx2 = find(strcmp(classes,tmp_c{j}));
                if isempty(idx2)
                    classes{k}=tmp_c{j};
                    k=k+1;
                end
            end
            break
        end
    end
    fclose(fid);
end
classes=sort(classes);
end
%--------------------------------------------------------------------------
% find unique number of classes
function [classes,STRUCT] = get_classes_MY(input_directory,files)
	classes={};
    STRUCT=[];
	num_files = length(files);
	k=1;
    	for i = 1:num_files
            STRUCT(i).num=i;
            STRUCT(i).file=files{i};
            
		g = strrep(files{i},'.mat','.hea');
		input_file = fullfile(input_directory, g);
	        fid=fopen(input_file);
	        tline = fgetl(fid);
        	tlines = cell(0,1);

		while ischar(tline)
        	    tlines{end+1,1} = tline;
	            tline = fgetl(fid);
			if startsWith(tline,'#Dx')
				tmp = strsplit(tline,': ');
				tmp_c = strsplit(tmp{2},',');
				for j=1:length(tmp_c)
                                        STRUCT(i).diagn{j}=tmp_c{j};

		                	idx2 = find(strcmp(classes,tmp_c{j}));
		                	if isempty(idx2)
                	        		classes{k}=tmp_c{j};
                        			k=k+1;
                			end
				end
			break
        		end
		end
        	fclose(fid);
	end
	classes=sort(classes)
end
%--------------------------------------------------------------------------
function [data,tlines] = load_challenge_data(filename)
% Opening header file
fid=fopen([filename '.hea']);

if (fid<=0)
    disp(['error in opening file ' filename]);
end
tline = fgetl(fid);
tlines = cell(0,1);
while ischar(tline)
    tlines{end+1,1} = tline;
    tline = fgetl(fid);
end
fclose(fid);
f=load([filename '.mat']);
try
    data = f.val;
catch ex
    rethrow(ex);
end
end
