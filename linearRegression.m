%% This file implements the logic required by linear regression, and make
% it easy to access to other modules

%% This method return a handler for the internal methods of the file
% so we can use something like:
% lr=linearRegression;
% lr.function1(x);
function functions=linearRegression
    functions.buildX=@buildX;
    functions.findFilter=@findFilter;
end

%% Creates the filter coeficients for: (XT X)^-1 (XT Y)
% -> featureMatrix is a matrix where rows are time bines, usually windows,
% and the columns have the features of the corresponding time bin, for each
% of the channels. ie:
%       time0 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
%       time1 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
%       time2 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
%       time3 -> ch1f1,ch1f2,ch1f3,ch2f1,ch2f2,ch2f3,ch3f1,ch3f2,ch3f3
% -> realOutput represent the measured output after the experiment ->
% numFeatures represent the number of features on for each channel on the
% data -> numBins represent how many time bins previous to the actual
% (including actual) will be used to build the filter that will be used on
% prediction.
function X=buildX(featureMatrix, numFeatures, numBins)
    disp(sprintf('Building X... \n'));
    numChannels=size(featureMatrix,2)/numFeatures;
    numTotalTimeBins=size(featureMatrix,1);
    
    numColumns=1+numBins*numFeatures*numChannels;
    numRows=numTotalTimeBins-numBins+1;

    % Build the X matrix
    % Iterate to fill the matrix, one row at the time
    X=zeros(numRows,numColumns);
    for r=1:numRows
        % Get the relevant data for the channel and bin, by creating a
        % submatrix 1) Select the rows for the number of bins
        dataRowStart=r;
        dataRowEnd=dataRowStart+numBins-1;
        % 2)Build a submatrix for each channel and its features
        rowData=[];
        for(ch=1:numChannels)
            dataColStart=(ch-1)*numFeatures+1;
            dataColEnd=dataColStart+numFeatures-1;
            data=featureMatrix(dataRowStart:dataRowEnd,...
                dataColStart:dataColEnd);
            % Now we convert the matrix into a row vector, column by column
            rowData=[rowData reshape(data.',[],1)'];
        end
        % We add the data to the X matrix
        X(r,:)=[1 rowData];
    end
    disp(sprintf('... Build X done. \n'));
end

function filter=findFilter(X, Y)
    disp(sprintf('Building filter... \n'));
    numRows=min(size(X,1),size(Y,1));
    X=X(1:numRows,:);
    Y=Y(1:numRows,:);
%     for i=1:size(Y,2)
%         smalValIndex=find(Y(:,i)<1);
%         Y(smalValIndex,i)=0;
%     end
    % Calculate the corresponding filters
    filter=(X'*X)\(X'*Y(1:numRows,:));
    disp(sprintf('... Filter done. \n'));
end
