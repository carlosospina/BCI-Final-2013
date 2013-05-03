%% This file implements the logic required by linear regression, and make
% it easy to access to other modules

%% This method return a handler for the internal methods of the file
% so we can use something like:
% lr=linearRegression;
% lr.function1(x);
function functions=linearRegression
    functions.createFilters=@createFilters;
end

%% Creates the filter coeficients for: (XT X)^-1 (XT Y)
% -> featureMatrix is a matrix where rows are time bines, usually windows, and
% the columns have the features of the corresponding time bin, for each of
% the channels. ie: 
%       time0 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
%       time1 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
%       time2 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
%       time3 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
% -> realOutput represent the meassured output after the experiment
% -> numFeatures represent the number of features on for each channel on
% the data
% -> numBins represent how many time bins previous to the actual 
% (including actual) will be used to build the filter that will be used on prediction.
function [filter]=createFilters(featureMatrix, realOutput, numFeatures, numBins)
%    numFeatures=size(featureMatrix,2)/numChannels;
    numChannels=size(featureMatrix,2)/numFeatures;
    numTotalTimeBins=size(featureMatrix,1)-numBins+1;
    
    numColumns=1+numBins*numFeatures*numChannels
    numRows=numTotalTimeBins

    % Build the X matrix
    % Iterate to fill the matrix, one row at the time
    X=zeros(numRows,numColumns);
    for r=1:numRows
        % Get the relevant data (submatrix)
        dataColStart=r;
        dataColEnd=dataColStart+numBins-1;
        data=featureMatrix(dataColStart:dataColEnd,:);
        % Now we convert the matrix into a row vector, column by column
        data=reshape(data.',[],1)';
        % We add the data to the X matrix
        X(r,:)=[1 data];
    end
    size(X)
    numColOutputs=size(realOutput,2);
    numRowOutputs=size(realOutput,1);
    filter=zeros(numRowOutputs,numColOutputs);
    % Calculate the corresponding filters
    size(realOutput(:,1))
    for(col=1:numColOutputs);
         filter(:,col)=(X'*X)\(X'*realOutput(:,col));
    end 
end