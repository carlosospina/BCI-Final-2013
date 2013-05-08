%% This method normalizes each column around its mean.
function [result]=normalizeByRow(data)
    % Mean per row
    tmpMean=mean(data,2);
    % StdDev per row
    tmpStd=std(data,0,2);
    % Column by column operation
    result=bsxfun(@rdivide,(bsxfun(@minus,data,tmpMean)),tmpStd);
end