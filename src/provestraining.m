function [predictedLabels] = provestraining(eyes, notEyes, tEyes, tNotEyes)

    numImages = 5;
    img = eyes(:,:,2);
    [hog_8x8, vis8x8] = extractHOGFeatures(img,'CellSize',[8 8]);
    cellSize = [8 8];
    hogFeatureSize = length(hog_8x8);

    trainingFeatures = zeros(numImages, hogFeatureSize, 'single');
    trainingLabels = zeros(numImages, 1);

    testFeatures = zeros(numImages, hogFeatureSize, 'single');
    testLabels = zeros(numImages, 1);

    for i = 1:numImages
        img = eyes(:,:,i);
        imgN = notEyes(:,:,i);
        Timg = tEyes(:,:,i);
        TimgN = tNotEyes(:,:,i);
        if mod(i,2) == 0
            trainingFeatures(i,:) = extractHOGFeatures(img, 'CellSize', cellSize);
            trainingLabels(i,1) = 1;
            testFeatures(i,:) = extractHOGFeatures(Timg, 'CellSize', cellSize);
            testLabels(i,1) = 1;
        else
            trainingFeatures(i,:) = extractHOGFeatures(imgN, 'CellSize', cellSize);
            trainingLabels(i,1) = 0;
            testFeatures(i,:) = extractHOGFeatures(TimgN, 'CellSize', cellSize);
            testLabels(i,1) = 0;
        end
    end

    % classifier = fitcecoc(trainingFeatures, trainingLabels);
    classifier = fitcsvm(trainingFeatures, trainingLabels);

    % Make class predictions using the test features.
    predictedLabels = predict(classifier, testFeatures);
    predictedLabels

end

