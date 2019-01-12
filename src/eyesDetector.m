function [ImOut] = eyesDetector(I)
%uses a sliding window to detect a pair of eyes within an image
%SVM HAS TO BE TRAINED BEFORE INVOKING THIS FUNCTION!
classifier = load('data\eyeClassifier.mat');

[F C] = size(I);

for i = 1:2:(F-32)
    for j = 1:4:(C-128)
        window = single(getHOG(I(i:i+31,j:j+127)));
        [label,score,cost] = predict(classifier.eyeClassifier, window);
        if(label==1) %eye detected 
            imshow(I(i:i+31,j:j+127));
            ImOut = insertShape(I,'Rectangle',[j i 128 32]);
            return
        end
        
    end
end
ImOut = [0];
f = msgbox('Input image contains no eyes','eyesDetector');
end