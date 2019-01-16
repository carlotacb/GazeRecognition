function [] = gazeTraining()

    if isfile('data\gazeClassifier.mat')
        delete('data\gazeClassifier.mat');
    end 

    Data = load('data\TrainData.mat');
    Data2 = load('data\GazeLabelsData.mat'); 

    hog = getHOG(Data.trainingEyes(:,:,1));
    %featureLBP = extractLBPFeatures(Data.trainingEyes(:,:,1), 'CellSize', [8 8]);
    featureSize = length(hog);

    trainigEyesSize = length(Data.trainingEyes);
    Features = zeros(trainigEyesSize, featureSize, 'single');
    Labels = Data2.Labels(1:length(Data.trainingEyes));

    for i = 1:length(Data.trainingEyes)
        imatge = Data.trainingEyes(:,:,i);
        featureHOG = single(getHOG(imatge));
        %featureLBP = extractLBPFeatures(imatge, 'CellSize', [8 8]);
        %Features(i,:) = horzcat(featureHOG, featureLBP);  
        Features(i,:) = featureHOG;
    end    
    
    gazeClassifier = fitcsvm(Features, Labels);    
    save('data\gazeClassifier.mat', 'gazeClassifier');

end