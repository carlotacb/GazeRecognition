function [] = gaze_testing()

    Data = load('data\TestData.mat');
    Data2 = load('data\GazeLabelsData.mat');
    classifier = load('data\gazeClassifier.mat');

    hog = getHOG(Data.testingEyes(:,:,1));
    featureLBP = extractLBPFeatures(Data.testingEyes(:,:,1));
    featureSize = length(hog)+length(featureLBP);

    testingEyesSize = length(Data.testingEyes);
    Features = zeros(testingEyesSize, featureSize, 'single');
    Labels = Data2.Labels(2738:end);
       
    for i = 1:length(Data.testingEyes) 
        imatge = Data.testingEyes(:,:,i);
        featureHOG = single(getHOG(imatge));
        featureLBP = extractLBPFeatures(imatge);
        Features(i,:) = horzcat(featureHOG, featureLBP);
    end   
    
    prediction = predict(classifier.gazeClassifier, Features);
    
    cmatrix = confusionmat(Labels, prediction);

    resultatMira = 100*cmatrix(1,1) / (cmatrix(1,1) + cmatrix(1,2))
    resultatNoMira = 100*cmatrix(2,2) / (cmatrix(2,1) + cmatrix(2,2))
    
    cchart = confusionchart(Labels, prediction);
end

