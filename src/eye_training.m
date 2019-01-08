function [] = eye_training()

    Data = load('data\TrainData.mat');
    
    % Marcarem amb un 1 les imatges que contenen ulls i amb un 0 les que no.    
    for i = 1:length(Data.trainingEyes)+length(Data.trainingNotEyes)
        if (i <= length(Data.trainingEyes))
            ulls = Data.trainingEyes(:,:,i);
            %Features(i,:) = extractHOGFeatures(ulls, 'CellSize', [8 8]);
            Features(i,:) = single(getHOG(ulls));
            Labels(i,1) = 1;
        else
            noUlls = Data.trainingNotEyes(:,:,i-length(Data.trainingEyes));
            %Features(i,:) = extractHOGFeatures(noUlls, 'CellSize', [8 8]);
            Features(i,:) = single(getHOG(noUlls));
            Labels(i,1) = 0;
        end 
    end
    
    eyeClassifier = fitcsvm(Features, Labels);    
    save('data\eyeClassifier.mat', 'eyeClassifier');
end

