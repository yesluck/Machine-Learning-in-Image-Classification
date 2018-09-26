function [net, info] = cnnRun_ResNet2()
% =========================================================================
% cnnRun : main function for trainning a net
% =========================================================================

clear;
close all;
clc;

% -------------------------------------------------------------------------
%                                                   Initialize  environment
% -------------------------------------------------------------------------
disp('--> Setup Matconvnet...');
matconvnetDir = 'E:\DevEnvironmentVS2015\matconvnet-1.0-beta23';
matlabDir = [matconvnetDir, '/matlab'];
run(fullfile(matlabDir, 'vl_setupnn.m'));


% -------------------------------------------------------------------------
%                                                        Initialize options
% -------------------------------------------------------------------------
disp('--> Initialize options...');
opts.dataDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset' ;
opts.expDir  = fullfile('exp-res2', 'image') ;

opts.numFetchThreads = 12 ;
opts.lite = false ;
opts.imdbPath = fullfile(opts.expDir, 'imdb.mat');

% training options(important: batch size, learning rate, numepochs)
opts.train = struct() ;
opts.train.gpus = [1];
opts.train.batchSize = 64 ;
opts.train.numSubBatches = 4 ;
opts.train.learningRate = 1e-5 * [0.1*ones(1, 5), ones(1,10), 0.1*ones(1,50)];
% opts.train.learningRate = 1e-6 * [5000, 5000, 5000, 10*ones(1,45), 100, 10*ones(1, 45)];
opts.train.learningRate = 1e-6 * [2000*ones(1, 20), 1000*ones(1, 40), 500*ones(1, 40)];
opts.train.numEpochs = 40;% numel(opts.train.learningRate);

% whether gpu is enabled
if ~isfield(opts.train, 'gpus'), opts.train.gpus = []; end;


% -------------------------------------------------------------------------
%                                                             Prepare model
% -------------------------------------------------------------------------
disp('--> Load pre-trained model...');
% net = load(opts.modelPath);
% net = prepareDINet(net,opts);
net = dagnn.DagNN.loadobj(load('imagenet-resnet-152-dag.mat'));
net = prepareResNet(net,opts);


% -------------------------------------------------------------------------
%                                                              Prepare data
% -------------------------------------------------------------------------
disp('--> Prepare data...');
if exist(opts.imdbPath,'file')
  imdb = load(opts.imdbPath) ;
else
  imdb = cnnSetupData('dataDir', opts.dataDir, 'lite', opts.lite) ;
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

imdb.images.set = imdb.images.sets;

% Set the class names in the network
net.meta.classes.name = imdb.classes.name ;
net.meta.classes.description = imdb.classes.name ;

% Set the average image 
imageStatsPath = fullfile(opts.expDir, 'imageStats.mat') ;
if exist(imageStatsPath)
  load(imageStatsPath, 'averageImage') ;
else
    averageImage = getImageStats(opts, net.meta, imdb) ;
    save(imageStatsPath, 'averageImage') ;
end

net.meta.normalization.averageImage = averageImage;


% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------
disp('--> Training...');
opts.train.train = find(imdb.images.set==1) ;
opts.train.val = find(imdb.images.set==3) ;
% train
[net, info] = cnn_train_dag(net, imdb, getBatchFn(opts, net.meta), ...
                            'expDir', opts.expDir, ...
                            opts.train) ;

                  
% -------------------------------------------------------------------------
%                                                                    Deploy
% -------------------------------------------------------------------------
disp('--> Deploy the trained model and save...');
net = cnnDeployNet(net) ;
modelPath = fullfile(opts.expDir, 'net-deployed.mat');

% deploy the network to save
net_ = net.saveobj() ;
save(modelPath, '-struct', 'net_') ;
clear net_ ;

% -------------------------------------------------------------------------
function fn = getBatchFn(opts, meta)
% -------------------------------------------------------------------------
useGpu = numel(opts.train.gpus) > 0 ;

bopts.numThreads = opts.numFetchThreads ;
bopts.imageSize = meta.normalization.imageSize ;
bopts.border = meta.normalization.border ;
bopts.averageImage = meta.normalization.averageImage ;

fn = @(x,y) getDagNNBatch(bopts,useGpu,x,y) ;


% -------------------------------------------------------------------------
function inputs = getDagNNBatch(opts, useGpu, imdb, batch)
% -------------------------------------------------------------------------
for i = 1:length(batch)
    if imdb.images.set(batch(i)) == 1 
        images(i) = strcat(imdb.imageDir.train, filesep , ...
                           imdb.images.name(batch(i)));
    else
        images(i) = strcat(imdb.imageDir.test, filesep , ...
                           imdb.images.name(batch(i)));
    end
end;
isVal = ~isempty(batch) && imdb.images.set(batch(1)) ~= 1 ;

if ~isVal
  % training
  im = cnnGetBatch(images, opts, ...
                   'prefetch', nargout == 0) ;
else
  % validation: disable data augmentation
  im = cnnGetBatch(images, opts, ...
                   'prefetch', nargout == 0, ...
                   'transformation', 'none') ;
end

if nargout > 0
  if useGpu
    im = gpuArray(im) ;
  end
  labels = imdb.images.label(batch) ;
  inputs = {'input', im, 'label', labels} ;
end

% -------------------------------------------------------------------------
function averageImage = getImageStats(opts, meta, imdb)
% -------------------------------------------------------------------------
train = find(imdb.images.set == 1) ;
batch = 1:length(train);
fn = getBatchFn(opts, meta) ;
train = train(1: 100: end);
avg = {};
for i = 1:length(train)
    temp = fn(imdb, batch(train(i): min(train(i)+99, batch(end)))) ;
    temp = temp{2};
    avg{end+1} = mean(temp, 4) ;
end

averageImage = mean(cat(4,avg{:}),4) ;
averageImage = gather(averageImage);