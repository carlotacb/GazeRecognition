function [] = eyeTesting()

    Data = load('data\TestData.mat');
    classifier = load('data\eyeClassifier.mat');
            
    for i = 1:length(Data.testingEyes)+length(Data.testingNotEyes)
        if (i <= length(Data.testingEyes)) 
            imatge = Data.testingEyes(:,:,i);
            expected(i,1) = 1;
        else 
            imatge = Data.testingNotEyes(:,:,i-length(Data.testingEyes));
            expected(i,1) = 0;
        end
        Features(i,:) = single(getHOG(imatge));
    end
    
    prediction = predict(classifier.eyeClassifier, Features);
    
    cmatrix = confusionmat(expected, prediction);
    cchart = confusionchart(expected, prediction);
    
    resultatNoUlls = 100*cmatrix(1,1) / (cmatrix(1,1) + cmatrix(1,2))
    resultatUlls = 100*cmatrix(2,2) / (cmatrix(2,1) + cmatrix(2,2))
    
    ((resultatUlls*length(Data.testingEyes))+(resultatNoUlls*length(Data.testingNotEyes)))/(length(Data.testingEyes)+length(Data.testingNotEyes))
end


     