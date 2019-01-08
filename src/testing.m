function [prediction] = testing()

    Data = load('C:\Users\catot\Documents\Personal\SPV2\data\TestData.mat');
    classifier = load('C:\Users\catot\Documents\Personal\SPV2\data\eyeClassifier.mat');
    
    %firstImatge = Data.testingEyes(:,:,1);
    %features = extractHOGFeatures(firstImatge,'CellSize',[8 8]);
    %Features(1,:) = features;
    %expected(1,1) = 1;
        
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
    
    result = transpose(prediction);
    cmatrix = confusionmat(expected, result);
    cchart = confusionchart(expected, result);
end

