%% Choose relevant data channels
% This function looks for the channels with relevant data
% and returns a matrix with only such channels
function chosenColumns = chooseColumns(data)
    numColumns=size(data,2);
    topNColumns=floor(numColumns*1);%50
    positiveData=normalizeByColumn(abs(data));

    colMean=mean(positiveData);
    colMax=max(positiveData);
    dataRelevance=colMax-colMean;
    [sortedValues,sortIndex] = sort(dataRelevance,'descend');
    chosenColumns=sortIndex(1,1:topNColumns)';
end