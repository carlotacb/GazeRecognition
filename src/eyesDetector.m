function [ImOut] = eyesDetector(Im)
%uses a sliding window to detect a pair of eyes within an image
%SVM HAS TO BE TRAINED BEFORE INVOKING THIS FUNCTION!
eyeClassifier = load('data\eyeClassifier.mat');
gazeClassifier = load('data\gazeClassifier.mat');
%for color images
if (size(Im,3) > 1)
    I = rgb2gray(Im);
else
    I=Im;
end

[F C] = size(I);
ImOut=Im;
eyesFound=0;
scores = [];
windows=[];

for i = 1:4:(F-31)
    for j = 1:4:(C-47)
        window = single(getHOG(I(i:i+31,j:j+47)));
        [label,score,cost] = predict(eyeClassifier.eyeClassifier, window);
        if(label==1) %eye detected 
            %ImOut = insertShape(ImOut,'Rectangle',[j i 48 32]);
            eyesFound=eyesFound+1;
            scores = cat(1,scores,score(2));
            windows = [windows;[j i 47 31]];
        end
        
    end
end
if(eyesFound==0)
    f = msgbox('Input image contains no eyes','eyesDetector');
    return
end
%point out the best candidates to be eyes in output image

[m,ind1] = max(scores);
ImOut = insertShape(ImOut,'Rectangle',windows(ind1,:));
scores(ind1)=[];
[m,ind2] = max(scores);
while(abs(windows(ind2,1)-windows(ind1,1)) < 24)   %try not to pick same eye twice
    scores(ind2)=[];
    [m,ind2] = max(scores);
end
ImOut = insertShape(ImOut,'Rectangle',windows(ind2,:));

%detect if eyes are looking towards camera

eye1 = single(getHOG(imcrop(I,windows(ind1,:))));

eye2 = single(getHOG(imcrop(I,windows(ind2,:))));

prediction1 = predict(gazeClassifier.gazeClassifier, eye1);
prediction2 = predict(gazeClassifier.gazeClassifier, eye2);

figure;imshow(ImOut);
if(prediction1 || prediction2)
    f = msgbox('The person is looking towards the camera','eyesDetector');
else
    f = msgbox('The person is NOT looking towards the camera','eyesDetector');
end
end