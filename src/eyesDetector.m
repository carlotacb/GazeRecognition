function [ImOut] = eyesDetector(Im)
%uses a sliding window to detect a pair of eyes within an image
%SVM HAS TO BE TRAINED BEFORE INVOKING THIS FUNCTION!
classifier = load('data\eyeClassifier.mat');
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
        [label,score,cost] = predict(classifier.eyeClassifier, window);
        if(label==1) %eye detected 
            %ImOut = insertShape(ImOut,'Rectangle',[j i 48 32]);
            eyesFound=eyesFound+1;
            scores = cat(1,scores,score(2));
            windows = [windows;[j i 48 32]];
        end
        
    end
end
if(eyesFound==0)
    f = msgbox('Input image contains no eyes','eyesDetector');
    return
end
%point out the best candidates to be eyes in output image
disp(scores);
[m,ind] = maxk(scores,2);
ImOut = insertShape(ImOut,'Rectangle',windows(ind(1),:));
while(abs(windows(ind(2),1)-windows(ind(1),1)) < 24)   %try not to pick same eye twice
    scores(ind(2))=[];
    [m,ind] = maxk(scores,2);
end
ImOut = insertShape(ImOut,'Rectangle',windows(ind(2),:));



end