%% RTWO function calulates the r2 estimation error
function [ r2 ] = rtwo(realValues, estimatedValues)
meanVal=mean(realValues);
difRealEst=realValues-estimatedValues;
difRealMean=realValues-meanVal;
r2=1-sum(difRealEst.^2)/sum(difRealMean.^2);