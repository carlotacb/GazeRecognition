function [] = training()

    Data = load('C:\Users\carlo\Documents\UNI\11quatri\SProject2\data\TrainData.mat');
    
    firstImatge = Data.trainingEyes(:,:,1);
    cellSize = [8 8];
    features = extractHOGFeatures(firstImatge,'CellSize',cellSize);
    hogFeatureSize = length(features);
    matSize = length(Data.trainingEyes)+length(Data.trainingNotEyes);

    trainingFeatures = zeros(matSize, hogFeatureSize, 'single');
    % Marquem amb 1 si es ull y amb 0 si no es ull.
    trainingLabels = zeros(matSize, 1);
        
    for i = 1:length(Data.trainingEyes)
        ulls = Data.trainingEyes(:,:,i);
        trainingFeatures(i,:) = extractHOGFeatures(ulls, 'CellSize', cellSize);
        trainingLabels(i,1) = 1;
        i
    end
    
    for i = 1:length(Data.trainingNotEyes)
        noUlls = Data.trainingNotEyes(:,:,i);
        trainingFeatures(i,:) = extractHOGFeatures(noUlls, 'CellSize', cellSize);
        trainingLabels(i,1) = 0;
        i
    end
    
    eyeClassifier = fitcsvm(trainingFeatures, trainingLabels);    
    
    save('C:\Users\carlo\Documents\UNI\11quatri\SProject2\data\eyeClassifier.mat', 'eyeClassifier');
end

