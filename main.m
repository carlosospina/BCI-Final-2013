%%
% <latex>
% \title{EL9113 \\{\normalsize Spring 2013}}
% \author{BCI Group}
% \date{1/13/2012}
% \maketitle
% </latex>

% clear the workspace and console
clear 
clc

%% Process the windows for all data samples
load('be521_sub1_compData.mat'); % Load the data for the first patient
Feature_array1=processWindows(train_data);
save('Feature1_1.mat','Feature_array1');

% load('be521_sub2_compData.mat'); % Load the data for the second patient
% Feature_array2=processWindows(train_data);
% save('Feature1_2.mat','Feature_array2');
% 
% load('be521_sub3_compData.mat'); % Load the data for the second patient
% Feature_array3=processWindows(train_data);
% save('Feature1_3.mat','Feature_array3');

%% Calculate
