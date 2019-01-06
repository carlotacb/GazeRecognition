function [prediction] = testing()

    Data = load('C:\Users\carlo\Documents\UNI\11quatri\SProject2\data\TestData.mat');
    classifier = load('C:\Users\carlo\Documents\UNI\11quatri\SProject2\data\eyeClassifier.mat');
    
    firstImatge = Data.testingEyes(:,:,1);
    cellSize = [8 8];
    features = extractHOGFeatures(firstImatge,'CellSize',cellSize);
    hogFeatureSize = length(features);
    matSize = length(Data.testingEyes)+length(Data.testingNotEyes);
    matSize
    %testingFeatures = zeros(matSize, hogFeatureSize, 'single');
        
    for i = 1:matSize
        if (i <= length(Data.testingEyes)) 
            ulls = Data.testingEyes(:,:,i);
            i
            testingFeatures(i,:) = extractHOGFeatures(ulls, 'CellSize', cellSize);
        else 
            noUlls = Data.testingNotEyes(:,:,i-length(Data.testingEyes));
            i-length(Data.testingEyes)
            hola = "segon for"
            testingFeatures(i-length(Data.testingEyes),:) = extractHOGFeatures(noUlls, 'CellSize', cellSize);
        end

    end
    
    prediction = predict(classifier.eyeClassifier, testingFeatures);
    
end

