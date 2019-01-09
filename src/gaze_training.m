function [] = gaze_training()

    Data = load('data\TrainData.mat');
    Data2 = load('data\GazeLabelsData.mat');
    
    for i = 1:length(Data.trainingEyes)
        ulls = Data.trainingEyes(:,:,i);
        Features(i,:) = single(getHOG(ulls));
    end
    
    Labels = Data2.trainigGLab;
    
    gazeClassifier = fitcsvm(Features, Labels);    
    save('data\gazeClassifier.mat', 'gazeClassifier');

end

