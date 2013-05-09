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
        

    %Remove last two windows, they would be incomplete or empty
    numRows=numRows-1;
    featureMatrix = zeros(numRows,numColumns);
    windowDisplacement=overlap/samplePeriod;
 
    % Get the frequency analysis for all data at once
    mySCell=cell(1,electrodes);
    disp(sprintf('\tExtracting frequency data for electrodes...\n'));
    for i=1:electrodes
        S= spectrogram(train_data(:,i),windowSize,windowSize/2,1000,fs);
        mySCell{i}=S;
        clear S;
    end
    disp(sprintf('\t...done\n'));
    % Process each row fo features
    for i=1:numRows
        if mod(i,100) == 0 
            disp(sprintf('\tProcessing window %d from %d...\n',i,numRows));
        end
        rowWindowStart=((i-1)*windowDisplacement)+startOffset+1;
        rowWindowEnd=rowWindowStart-1+windowSize;
        windowData=train_data(rowWindowStart:rowWindowEnd,:);
        featureRow=zeros(1,numColumns);
        for e = 1:electrodes
            % get frequency data for the correct window and electrode
            sFreqData= mySCell{e}(:,i);
            baseColumn=(e-1)*numFeatures;
            % Calculate mean
            featureRow(baseColumn+1)=mean(windowData(:,e));
            % Calculate frquency features
            %6Hz to 15Hz
            featureRow(baseColumn+2) = mean(abs(sFreqData(7:16,:)));   
            %21Hz to 25Hz
            featureRow(baseColumn+3) = mean(abs(sFreqData(22:26,:)));
            %76Hz to 115Hz
            featureRow(baseColumn+4) = mean(abs(sFreqData(77:116,:)));
            %126Hz to 160Hz
            featureRow(baseColumn+5) = mean(abs(sFreqData(127:161,:)));
            %161Hz to 175Hz
            featureRow(baseColumn+6) = mean(abs(sFreqData(162:176,:)));
        end
        featureMatrix(i,:)=featureRow;
        clear featureRow;
        clear sFreqData;
%         featureMatrix(i,:)=calcFeatures(windowData,fs);
    end
    clear mySCell;
    disp(sprintf('... done processing windows\n'));
 end



