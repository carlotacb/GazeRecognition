function [] = eyeTraining()

    if isfile('data\eyeClassifier.mat')
         delete('data\eyeClassifier.mat');
    end
    
    Data = load('data\TrainData.mat');
    
    hog = getHOG(Data.trainingEyes(:,:,1));
    featureSize = length(hog);

    trainigEyesSize = length(Data.trainingEyes);
    trainigEyesNotSize = length(Data.trainingNotEyes);
    totalSize = trainigEyesSize+trainigEyesNotSize;
    
    Features = zeros(totalSize, featureSize, 'single');
    Labels = [ones(trainigEyesSize,1); zeros(trainigEyesNotSize,1)];
    
    for i = 1:length(Data.trainingEyes)+length(Data.trainingNotEyes)
        if (i <= length(Data.trainingEyes))
            imatge = Data.trainingEyes(:,:,i);
        else
            imatge = Data.trainingNotEyes(:,:,i-length(Data.trainingEyes));
        end
        Features(i,:) = single(getHOG(imatge));   
    end
    
    eyeClassifier = fitcsvm(Features, Labels);    
    save('data\eyeClassifier.mat', 'eyeClassifier');
end