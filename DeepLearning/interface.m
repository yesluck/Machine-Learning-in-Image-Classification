clear;
close all;

%% directories
matconvnetDir = 'E:\DevEnvironmentVS2015\matconvnet-1.0-beta23';

trainDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset\train_img_forstu';
validDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset\valid_img_forstu';

%% train and test
% [net, info] = cnnRun_MyNet1( matconvnetDir, trainDir, validDir );
% [net, info] = cnnRun_MyNet2( matconvnetDir, trainDir, validDir );
[net, info] = cnnRun_ResNet( matconvnetDir, trainDir, validDir );
info

%% save the model
% net2 = cnnNetDeploy(net);
net2 = net.saveobj();
modelPath = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\MatConvNetCode\data\modelResNet.mat';
save(modelPath, '-struct', 'net2') ;


[net, info] = cnnRun_VggNet( matconvnetDir, trainDir, validDir );
net2 = cnnNetDeploy(net);
modelPath = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\MatConvNetCode\data\modelVggnet.mat';
save(modelPath, '-struct', 'net2') ;

