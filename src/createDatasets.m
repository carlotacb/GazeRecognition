function [] = createDatasets()
%createDatasets this function creates and saves to disk the 4 datasets
%needed for the short project: trainingEyes, trainingNotEyes,
%testingEyes, testingNotEyes
%   this function reads and writes to ..\data
clc;
clear;

notEyes = zeros([32,128,1521*19]);
eyeStrips = zeros([32,128,1521]);
eyeCoords = zeros(1,4,1521);

%llegir les posicions
searchfolder = 'C:\Users\carlo\Documents\UNI\11quatri\SProject2\data\originalDataset';
eyeLocs = dir(fullfile(searchfolder, '*.eye'));
peopleImages = dir(fullfile(searchfolder, 'BioID*.pgm'));

for idx = 1:numel(eyeLocs)
    fi = eyeLocs(idx);
    eyeCoordsFile = fopen(strcat(fullfile(searchfolder, fi.name)));
    textscan(eyeCoordsFile,'%s %s %s %s',1);
    eyeCoords(:,:,idx)= double(cell2mat(textscan(eyeCoordsFile,'%d %d %d %d',1)));
    fclose('all'); 
end 

%eyeCoords = matrix containing positions of both eyes

%abans de fer mes calculs, netejar les variables inutils?
clearvars eyeLocs
%now, from all the images of people, extract only the part with eyes

for i = 1:1521
    Im = imread(fullfile(searchfolder, peopleImages(i).name));
    [F C] = size(Im);
    center1 = eyeCoords(1,1:2,i); %LX LY
    center2 = eyeCoords(1,3:4,i); %RX RY
    dist = uint32(abs(center2(1)-center1(1))*0.3);
    disty = dist/2;
    
    left = max(1,min(center1(1),center2(1))-dist);
    right = min(C,max(center1(1),center2(1))+dist);
    top = max(1, min(center1(2),center2(2)) - disty);
    bot = min(F, max(center1(2),center2(2)) + disty);
    eyeStrips(:,:,i) = imresize(Im(top:bot,left:right),[32,128]);
end
%eyeStrips es una array de rectangles que contenen els ulls de cada imatge

n = 1521;  %nombre d'imatges d'on agafar samples de no ulls
for i = 1:n
    Im = imread(fullfile(searchfolder, peopleImages(i).name));
    [F C] = size(Im);
    for j = 1:19
        y = randi(F-32);    %y and x are the upper left coords of the window
        x = randi(C-128);
        %ens hem d'assegurar que no agafem del troç amb ulls
        while  (x < eyeCoords(1,1,i) && eyeCoords(1,1,i) < (x+127) || ...
                x < eyeCoords(1,3,i) && eyeCoords(1,3,i) < (x+127)) && ...
               (y < eyeCoords(1,2,i) && eyeCoords(1,2,i) < (y+31) || ...
                y < eyeCoords(1,4,i) && eyeCoords(1,4,i) < (y+31))
            y = randi(F-32);    %y and x are the upper left coords of the window
            x = randi(C-128);
        end
        %afegir l'imatge a noteyes
        notEyes(:,:,(i-1)*19+j) = Im(y:y+31,x:x+127);
    end
end
%crear els sets d'imatges de training i de testing
nEyes = uint32(size(eyeStrips,3))-1;
nNotEyes = uint32(size(notEyes,3))-1;
trainingEyes = eyeStrips(:,:,1:nEyes*0.9);
trainingNotEyes = notEyes(:,:,1:nNotEyes*0.9); 
testingEyes = eyeStrips(:,:,nEyes*0.9+1:end);
testingNotEyes = notEyes(:,:,nNotEyes*0.9+1:end); 

%save to file
save('C:\Users\carlo\Documents\UNI\11quatri\SProject2\data\TrainData.mat', 'trainingEyes','trainingNotEyes');
save('C:\Users\carlo\Documents\UNI\11quatri\SProject2\data\TestData.mat', 'testingEyes','testingNotEyes');

end

