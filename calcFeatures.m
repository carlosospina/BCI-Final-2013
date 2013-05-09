
%%
% data - Windowed data 100 x 62 
function Feature_array = calcFeatures( data, freqData )
    windowSize=size(data,1);
    Electrodes=size(data,2);
    numFeatures=6;
    Feature_array = zeros(1,numFeatures*Electrodes);    

    for i = 1:Electrodes
        baseColumn=(i-1)*numFeatures;
        % Calculate mean
        Feature_array(baseColumn+1)=mean((data(:,i)));
        % Calculate frquency features
        S = spectrogram(data(:,i),windowSize,windowSize/2,1000,fs);
        %6Hz to 15Hz
        Feature_array(baseColumn+2) = mean(abs(S(7:16,:)));   
        %21Hz to 25Hz
        Feature_array(baseColumn+3) = mean(abs(S(22:26,:)));
        %76Hz to 115Hz
        Feature_array(baseColumn+4) = mean(abs(S(77:116,:)));
        %126Hz to 160Hz
        Feature_array(baseColumn+5) = mean(abs(S(127:161,:)));
        %161Hz to 175Hz
        Feature_array(baseColumn+6) = mean(abs(S(162:176,:)));
        clear S;
    end
end






