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
    disp(sprintf('Processing windows ...\n'));
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
        

    %Remove last window, it would be incomplete or empty
    numRows=numRows-1;
    featureMatrix = zeros(numRows,numColumns);
    windowDisplacement=overlap/samplePeriod;
 
    % Get the frequency analysis for all data at once
    disp(sprintf('\tExtracting frequency related data for electrodes...\n'));
    for i=1:electrodes
        disp(sprintf('\tProcessing electrode: %d',i));       
        % Define the position of the features in the matrix
        posFeat1=(1:numFeatures:numColumns);
        posFeat2=(2:numFeatures:numColumns);
        posFeat3=(3:numFeatures:numColumns);
        posFeat4=(4:numFeatures:numColumns);
        posFeat5=(5:numFeatures:numColumns);
        posFeat6=(6:numFeatures:numColumns);
        
        S= spectrogram(train_data(:,i),windowSize,windowSize/2,1000,fs);
        featureMatrix(:,posFeat1(1,i))=0;
        featureMatrix(:,posFeat2(1,i))=abs(mean(S(7:16,:)))';
        featureMatrix(:,posFeat3(1,i))=abs(mean(S(22:26,:)))';
        featureMatrix(:,posFeat4(1,i))=abs(mean(S(77:116,:)))';
        featureMatrix(:,posFeat5(1,i))=abs(mean(S(127:161,:)))';
        featureMatrix(:,posFeat6(1,i))=abs(mean(S(162:176,:)))';
        clear S;
    end
    disp(sprintf('\t...done\n'));
   
    % Get the time analysis for all data at once
    disp(sprintf('\tExtracting time related data for electrodes...\n'));
    for i=1:numRows
        if mod(i,100) == 0 
            disp(sprintf('\tProcessing window %d from %d...',i,numRows));
        end
        rowWindowStart=((i-1)*windowDisplacement)+startOffset+1;
        rowWindowEnd=rowWindowStart-1+windowSize;
        windowData=train_data(rowWindowStart:rowWindowEnd,:);
        % Define the position of the features in the matrix
        posFeat1=(1:numFeatures:numColumns);
        for e = 1:electrodes
            % Calculate mean
            featureMatrix(i,posFeat1(1,e))=mean(windowData(:,e));
        end
%         featureMatrix(i,:)=calcFeatures(windowData,fs);
    end
    disp(sprintf('... done processing windows\n'));
 end



