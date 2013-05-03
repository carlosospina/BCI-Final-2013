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

function [featureMatrix]=processWindows(train_data)
    windowSize = 100; % window size
    overlap = 50e-3; %overlap time in s
    fs=1000; %sampling frequency 1Khz
    samplePeriod=1/fs; % sampling period
    numFeatures = 6;
    totalSamples=size(train_data,1);
    electrodes = size( train_data,2 );
       
    % Rows represent how many windows we'll have
    numRows=floor(totalSamples*samplePeriod)/overlap;
    numColumns=electrodes*numFeatures;
    %We may have some samples at the begining of the data 
    %that will be ignored to have complete window
    startOffset=totalSamples-numRows*overlap/samplePeriod;
        

    %Remove last two windows, they would be incomplete or empty
    numRows=numRows-1;
    featureMatrix = zeros(numRows,numColumns);
    windowDisplacement=overlap/samplePeriod;
    for(i=1:numRows)
        disp(sprintf('Processing window %d from %d...\n',i,numRows));
        rowWindowStart=((i-1)*windowDisplacement)+startOffset+1;
        rowWindowEnd=rowWindowStart-1+windowSize;
        windowData=train_data(rowWindowStart:rowWindowEnd,:);
        featureMatrix(i,:)=calcFeatures(windowData,fs);
    end
    disp(sprintf('Done processing windows\n'));
    featureMatrix
 end



