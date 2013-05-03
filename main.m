%%
% <latex>
% \title{EL9113 \\{\normalsize Spring 2013}}
% \author{BCI Group}
% \Carlos Ospina
% \Jordan Wolf
% \Chinmay Nanda
% \date{1/13/2012}
% \maketitle
% </latex>

% clear the workspace and console
clc

%% Process the windows for all data samples
load('be521_sub1_compData.mat'); % Load the data for the first patient
%[train_datx, train_daty, test_datx, test_daty] = Folding(train_data,train_dg);
%featureMatrix=processWindows(train_datx);
load('Feature1_1.mat','Feature_array1');
featureMatrix=Feature_array1;

%% Downsample Y by 50
size_train_dg=size(train_dg);
numColsY=size(train_dg,2);
numRowsY=size(train_dg,1)/50;
y=zeros(numRowsY,numColsY);
for(i=1:numColsY)
    data=train_dg(:,i)';
    y(:,i)=(decimate(decimate(data,10),5))';
end
%Remove last row
y=y(1:end-1,:);
%Create coficients for classifier
lr=linearRegression;
[filter]=lr.createFilters(featureMatrix, y, 6, 3);