function my_train_model(input_directory, output_directory,K_ini,K_end,K_TRAIN)
if(nargin<3),K_ini=0;end
if(nargin<4),K_end=0;end
if(nargin<5),K_TRAIN=0;end

% *** Do not edit this script.
% Train models for three different ECG leads sets

if ~exist(output_directory, 'dir')
    mkdir(output_directory)
end

disp('Running training code...')
team_training_code(input_directory,output_directory,K_ini,K_end,K_TRAIN); %team_training_code>train ECG leads classifier

disp('Done.')
end
