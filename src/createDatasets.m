function [] = createDatasets()
%createDatasets this function creates and saves to disk the 4 datasets
%needed for the short project: trainingEyes, trainingNotEyes,
%testingEyes, testingNotEyes
%   this function reads and writes to ..\data
clc;
clear;

if isfile('data\TestData.mat')
     delete('data\TestData.mat');
end  

if isfile('data\TrainData.mat')
     delete('data\TrainData.mat');
end  

if isfile('data\GazeLabelsData.mat')
     delete('data\GazeLabelsData.mat');
end 

notEyes = zeros([32,48,1521*19*2]);
eyeStrips = zeros([32,48,1521*2]);
eyeCoords = zeros(1,4,1521);

%llegir les posicions
eyeLocs = dir(fullfile('data\originalDataset', '*.eye'));
peopleImages = dir(fullfile('C:\Users\catot\Documents\Personal\VC\SP12\data\originalDataset', 'BioID*.pgm'));

for idx = 1:numel(eyeLocs)
    fi = eyeLocs(idx);
    eyeCoordsFile = fopen(strcat(fullfile('data\originalDataset', fi.name)));
    textscan(eyeCoordsFile,'%s %s %s %s',1);
    eyeCoords(:,:,idx)= double(cell2mat(textscan(eyeCoordsFile,'%d %d %d %d',1)));
    fclose('all'); 
end 

%eyeCoords = matrix containing positions of both eyes

%abans de fer mes calculs, netejar les variables inutils?
clearvars eyeLocs
%now, from all the images of people, extract only the part with eyes

for i = 1:2:3041
    ind = ceil(i/2);
    Im = imread(fullfile('data\originalDataset', peopleImages(ind).name));
    [F C] = size(Im);
    center1 = eyeCoords(1,1:2,ind); %LX LY
    center2 = eyeCoords(1,3:4,ind); %RX RY
    dist = uint32(abs(center2(1)-center1(1))*0.325);
    disty = dist/2;
    
    left1 = max(1,center1(1)-dist);
    right1 = min(C,center1(1)+dist);
    top1 = max(1, center1(2) - disty);
    bot1 = min(F, center1(2) + disty);
    
    left2 = max(1,center2(1)-dist);
    right2 = min(C,center2(1)+dist);
    top2 = max(1, center2(2) - disty);
    bot2 = min(F, center2(2) + disty);
    
    
    eyeStrips(:,:,i) = imresize(Im(top1:bot1,left1:right1),[32,48]);
    eyeStrips(:,:,i+1) = imresize(Im(top2:bot2,left2:right2),[32,48]);
end
%eyeStrips es una array de rectangles que contenen els ulls de cada imatge

n = 1521;  %nombre d'imatges d'on agafar samples de no ulls
for i = 1:n
    Im = imread(fullfile(peopleImages(i).folder, peopleImages(i).name));
    [F C] = size(Im);
    for j = 1:38
        y = randi(F-32);    %y and x are the upper left coords of the window
        x = randi(C-48);
        %ens hem d'assegurar que no agafem del troç amb ulls
        while  (x < eyeCoords(1,1,i) && eyeCoords(1,1,i) < (x+48) || ...
                x < eyeCoords(1,3,i) && eyeCoords(1,3,i) < (x+48)) && ...
               (y < eyeCoords(1,2,i) && eyeCoords(1,2,i) < (y+32) || ...
                y < eyeCoords(1,4,i) && eyeCoords(1,4,i) < (y+32))
            y = randi(F-32);    %y and x are the upper left coords of the window
            x = randi(C-128);
        end
        %afegir l'imatge a noteyes
        notEyes(:,:,(i-1)*38+j) = Im(y:y+31,x:x+47);
    end
end
%afegir imatges que només tinguin un ull a notEyes?


%crear els sets d'imatges de training i de testing
nEyes = uint32(size(eyeStrips,3))-1;
nNotEyes = uint32(size(notEyes,3))-1;
trainingEyes = eyeStrips(:,:,1:nEyes*0.9);
trainingNotEyes = notEyes(:,:,1:nNotEyes*0.9); 
testingEyes = eyeStrips(:,:,nEyes*0.9+1:end);
testingNotEyes = notEyes(:,:,nNotEyes*0.9+1:end); 

%save to file
save('data\TrainData.mat', 'trainingEyes','trainingNotEyes');
save('data\TestData.mat', 'testingEyes','testingNotEyes');

expectedLabels = xlsread("data\Miram.xlsx", 1, "E5:E1525");
j = 1;
for i = 1:1521*2
    if mod(i,2) == 0
       Labels(i,1) = expectedLabels(j);
       j = j+1;
    else
       Labels(i,1) = expectedLabels(j);
    end 
end

save('data\GazeLabelsData.mat', 'Labels')

end

