function [] = training()

    Data = load('C:\Users\catot\Documents\Personal\SPV2\data\TrainData.mat');
    
    % Marcarem amb un 1 les imatges que contenen ulls i amb un 0 les que no.
    
    %firstImatge = Data.trainingEyes(:,:,1);
    %features = extractHOGFeatures(firstImatge,'CellSize',[8 8]);
    %Features(1,:) = features;
    %Labels(1,1) = 1;
        
    for i = 1:length(Data.trainingEyes)+length(Data.trainingNotEyes)
        if (i <= length(Data.trainingEyes))
            ulls = Data.trainingEyes(:,:,i);
            Features(i,:) = extractHOGFeatures(ulls, 'CellSize', [8 8]);
            Labels(i,1) = 1;
        else
            noUlls = Data.trainingNotEyes(:,:,i-length(Data.trainingEyes));
            Features(i,:) = extractHOGFeatures(noUlls, 'CellSize', [8 8]);
            Labels(i,1) = 0;
        end 
    end
    
    eyeClassifier = fitcsvm(Features, Labels);    
    
    save('C:\Users\catot\Documents\Personal\SPV2\data\eyeClassifier.mat', 'eyeClassifier');
end

