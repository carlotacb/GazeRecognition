function [] = eye_testing()

    Data = load('data\TestData.mat');
    classifier = load('data\eyeClassifier.mat');
            
    for i = 1:length(Data.testingEyes)+length(Data.testingNotEyes)
        if (i <= length(Data.testingEyes)) 
            ulls = Data.testingEyes(:,:,i);
            Features(i,:) = single(getHOG(ulls));
            expected(i,1) = 1;
        else 
            noUlls = Data.testingNotEyes(:,:,i-length(Data.testingEyes));
            Features(i,:) = single(getHOG(noUlls));
            expected(i,1) = 0;
        end

    end
    
    prediction = predict(classifier.eyeClassifier, Features);
    
    cmatrix = confusionmat(expected, prediction);
    cchart = confusionchart(expected, prediction);
    
    resultatUlls = 100*cmatrix(1,1) / (cmatrix(1,1) + cmatrix(1,2))
    resultatNoUlls = 100*cmatrix(2,2) / (cmatrix(2,1) + cmatrix(2,2))
end

