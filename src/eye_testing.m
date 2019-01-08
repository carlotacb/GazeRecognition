function [prediction, cmatrix] = eye_testing()

    Data = load('data\TestData.mat');
    classifier = load('data\eyeClassifier.mat');
            
    for i = 1:length(Data.testingEyes)+length(Data.testingNotEyes)
        if (i <= length(Data.testingEyes)) 
            ulls = Data.testingEyes(:,:,i);
            Features(i,:) = extractHOGFeatures(ulls, 'CellSize', [8 8]);
            expected(i,1) = 1;
        else 
            noUlls = Data.testingNotEyes(:,:,i-length(Data.testingEyes));
            Features(i,:) = extractHOGFeatures(noUlls, 'CellSize', [8 8]);
            expected(i,1) = 0;
        end

    end
    
    prediction = predict(classifier.eyeClassifier, Features);
    
    cmatrix = confusionmat(expected, prediction);
    cchart = confusionchart(expected, prediction);
end

