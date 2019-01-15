function [] = eye_training()

    Data = load('data\TrainData.mat');
    
    Labels = [ones(length(Data.trainingEyes),1); zeros(length(Data.trainingNotEyes),1)];     
    
    for i = 1:length(Data.trainingEyes)+length(Data.trainingNotEyes)
        if (i <= length(Data.trainingEyes))
            ulls = Data.trainingEyes(:,:,i);
            Features(i,:) = single(getHOG(ulls));
        else
            noUlls = Data.trainingNotEyes(:,:,i-length(Data.trainingEyes));
            Features(i,:) = single(getHOG(noUlls));
        end 
    end
    
    eyeClassifier = fitcsvm(Features, Labels);    
    save('data\eyeClassifier.mat', 'eyeClassifier');
end
