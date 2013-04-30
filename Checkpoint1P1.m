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

%% 
% <latex>
% \section{Plotting}
% </latex>
% The section contains the following parts implemented
% 1. A moving window 100 ms in length with 50 ms overlap 
% 2.average time-domain voltage, and the average frequency-domain magnitude
% in five frequency bands: 5-15 Hz, 20-25 Hz, 75- 115 Hz, 125-160 Hz,
% 160-175 Hz. (N.B., the conv and spectrogram functions, respectively, were
% very helpful for this.) Thus, the total number of features in a given
% time window was 62(5 + 1) = 372 for a subject with 62 EEG channels.

load('be521_sub1_compData.mat'); % Load the data for the first patient

%%

WindowSize = 100; % block length
Bins = 2*500;
Overlap = 50;
Fs = 1000; % fs: sampling frequency
Num_features = 6;
decimation_factor = 100;

Overlap_factor = WindowSize / Overlap; % Since we have 50 ms overlap so 
Rows = size( train_data,1 );
Electrodes = size( train_data,2 );
feat_rows = size( train_data,1 ) * Overlap_factor / decimation_factor;
feat_column = Electrodes * (Num_features ) ;

Feature_array1 = zeros( feat_rows - 1 ,feat_column );  
Feature_array1 = Calc_features( train_data);
save('Feature1_1.mat','Feature_array1');

load('be521_sub2_compData.mat'); % Load the data for the second patient
Feature_array2 = zeros( feat_rows - 1 ,feat_column );  
Feature_array2 = Calc_features( train_data);
save('Feature1_2.mat','Feature_array2');

load('be521_sub3_compData.mat'); % Load the data for the third patient
Feature_array3 = zeros( feat_rows - 1 ,feat_column );  
Feature_array3 = Calc_features( train_data);
save('Feature1_3.mat','Feature_array3');




