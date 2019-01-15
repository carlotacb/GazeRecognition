function [] = gaze_training()

    if isfile('data\gazeClassifier.mat')
        delete('data\gazeClassifier.mat');
    end 

    Data = load('data\TrainData.mat');
    Data2 = load('data\GazeLabelsData.mat'); 

    hog = getHOG(Data.trainingEyes(:,:,1));
    featureLBP = extractLBPFeatures(Data.trainingEyes(:,:,1));
    %hist = histogram(Data.trainingEyes(:,:,1),'EdgeColor','k','NumBins',16);
    %featureshist = single(hist.Values);
    featureSize = length(hog)+length(featureLBP);

    trainigEyesSize = length(Data.trainingEyes);
    Features = zeros(trainigEyesSize, featureSize, 'single');
    Labels = Data2.Labels(1:length(Data.trainingEyes));

    for i = 1:length(Data.trainingEyes)
        imatge = Data.trainingEyes(:,:,i);
        featureHOG = single(getHOG(imatge));
        featureLBP = extractLBPFeatures(imatge);
        %hist = histogram(imatge,'EdgeColor','k','NumBins',16);
        %featureshist = single(hist.Values);
        Features(i,:) = horzcat(featureHOG, featureLBP);        
    end    
    
    gazeClassifier = fitcsvm(Features, Labels);    
    save('data\gazeClassifier.mat', 'gazeClassifier');

end