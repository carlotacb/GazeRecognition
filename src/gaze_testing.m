function [prediction, cmatrix] = gaze_testing()

    Data = load('data\TestData.mat');
    classifier = load('data\gazeClassifier.mat');
    Data2 = load('data\GazeLabelsData.mat');
            
    for i = 1:length(Data.testingEyes) 
        ulls = Data.testingEyes(:,:,i);
        Features(i,:) = single(getHOG(ulls));
    end
    
    expected = Data2.testingGLab();
    
    prediction = predict(classifier.gazeClassifier, Features);
    
    cmatrix = confusionmat(expected, prediction);
    cchart = confusionchart(expected, prediction);

end

