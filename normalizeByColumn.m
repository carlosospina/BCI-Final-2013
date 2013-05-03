%% This method normalizes each column around its mean.
function [result]=normalizeByColumn(data)
    tmpMean=mean(data);
    tmpStd=std(data);
    numColumns=size(data,2);
    numRows=size(data,1);
    result=zeros(numRows,numColumns);
    for i=1:numColumns
        result(:,i)=(data(:,i)-tmpMean(i))./tmpStd(i);
    end 
end