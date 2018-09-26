function PROJ2

    hog=0;
    
    if hog==0
        Pick('train_forstu.pickle');
        importTrainData = importdata('train_forstu.pickle.mat');
        Pick('valid_forstu.pickle');
        importValidData = importdata('valid_forstu.pickle.mat');
    end
    
    if hog==1
        Character(1);
        importTrainData = importdata('train_mine.mat');
        Character(2);
        importValidData = importdata('valid_mine.mat');
    end
    
    [~,trainY] = size(importTrainData);
    [~,validY] = size(importValidData);
    
%     SVMa(importTrainData,importValidData,trainY,validY,0);
%     kNNa(importTrainData,importValidData,trainY,validY,0);
%     NEUa(importTrainData,importValidData,trainY,validY,0);
%     SoftmaxA(importTrainData,importValidData,trainY,validY,0);
    SoftmaxB(importTrainData,importValidData,trainY,validY,0);
end