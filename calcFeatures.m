
%%
% data - Windowed data 100 x 62 
function Feature_array = calcFeatures( data, fs, numFeatures )
    windowSize=size(data,1);
    Electrodes=size(data,2);
    Feature_array = zeros(1,numFeatures*Electrodes);    

    for i = 1:Electrodes
        baseColumn=(i-1)*numFeatures;
        % Calculate mean
        baseColumn=baseColumn+1;
        Feature_array(baseColumn)=mean((data(:,i)));

        % Calculate frquency features
        S = spectrogram(data(:,i),windowSize,windowSize/2,1000,fs);

        S = S';
        %6Hz to 15Hz
        baseColumn=baseColumn+1;
        Feature_array(baseColumn) = mean(abs(S(:,7:16)'))';   
        %21Hz to 25Hz
        baseColumn=baseColumn+1;
        Feature_array(baseColumn) = mean(abs(S(:,22:26)'))';
        %76Hz to 115Hz
        baseColumn=baseColumn+1;
        Feature_array(baseColumn) = mean(abs(S(:,77:116)'))';
        %126Hz to 160Hz
        baseColumn=baseColumn+1;
        Feature_array(baseColumn) = mean(abs(S(:,127:161)'))';
        %161Hz to 175Hz
        baseColumn=baseColumn+1;
        Feature_array(baseColumn) = mean(abs(S(:,162:176)'))';
        clear S;
    end
end






