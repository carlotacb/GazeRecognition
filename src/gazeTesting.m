function [resultatNoMira, resultatMira, encert, prediction] = gazeTesting()
    Data = load('data\TestData.mat');
    classifier = load('data\gazeClassifier.mat');
    Data2 = load('data\GazeLabelsData.mat');
    Labels = Data2.Labels(2738:end);
       
    for i = 1:length(Data.testingEyes) 
        imatge = Data.testingEyes(:,:,i);
        featureHOG = single(getHOG(imatge));
        %featureLBP = extractLBPFeatures(imatge, 'CellSize', [8 8]);
        %Features(i,:) = horzcat(featureHOG, featureLBP);
        Features(i,:) = featureHOG;
    end   
    
    prediction = predict(classifier.gazeClassifier, Features);
    
    cmatrix = confusionmat(Labels, prediction);
    resultatNoMira = 100*cmatrix(1,1) / (cmatrix(1,1) + cmatrix(1,2));
    resultatMira = 100*cmatrix(2,2) / (cmatrix(2,1) + cmatrix(2,2));
    
    encert = ((resultatMira*245)+(resultatNoMira*60))/length(Data.testingEyes);
    
    cchart = confusionchart(Labels, prediction);
end

