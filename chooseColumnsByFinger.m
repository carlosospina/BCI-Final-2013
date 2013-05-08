%% Choose relevant data channels
% Correlate all channels in data for a given finger Y, 
function chosenColumns = chooseColumnsByFinger(data,y)
    numColumns=size(data,2);
    corrVals=zeros(1,numColumns);
    % Delay data to fit with y
    delay=200;
    pad=zeros(delay,numColumns);
    tmpData=data(1:end-delay,:);
    data=[pad;tmpData];
    for i=1:numColumns
        corrVals(1,i)=corr(data(:,i),y);
    end
    [sortedValues,sortIndex] = sort(abs(corrVals),'descend');
    topNColumns=find(sortedValues>=0.01,1,'last');
    if topNColumns==0 
        topNColumns=numColumns;
    end
    sortedValues
    topNColumns
    chosenColumns=sortIndex(1,1:topNColumns);
end