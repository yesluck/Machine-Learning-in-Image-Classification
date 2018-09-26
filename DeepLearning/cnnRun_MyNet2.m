function [ net, info ] = cnnRun_MyNet2()
% =========================================================================
% cnnRun : main function for trainning a net
% =========================================================================

matconvnetDir = 'E:\DevEnvironmentVS2015\matconvnet-1.0-beta23';

trainDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset\train_img_forstu';
validDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset\valid_img_forstu';

% -------------------------------------------------------------------------
%                                                   Initialize  environment
% -------------------------------------------------------------------------
disp('--> Setup Matconvnet...');
matlabDir = [matconvnetDir, '/matlab'];
run(fullfile(matlabDir, 'vl_setupnn.m'));

% -------------------------------------------------------------------------
%                                         Initialize options and networking
% -------------------------------------------------------------------------
disp('--> Initialize options...');
opts.batchNormalization = false ;
opts.networkType = 'simplenn' ;

opts.expDir  = fullfile('exp-mynet', 'image') ;
opts.imdbPath = fullfile('exp-mynet', '\image\imdb.mat');
opts.train = struct() ;
opts.train.gpus = [1];

net = cnnNetInit2('networkType', opts.networkType);
% net = dagnn.DagNN.fromSimpleNN(net, 'canonicalNames', true) ;
% net.addLayer('top1err', dagnn.Loss('loss', 'classerror'), ...
%   {'prediction', 'label'}, 'error') ;
% net.addLayer('top5err', dagnn.Loss('loss', 'topkerror', ...
%   'opts', {'topk', 5}), {'prediction', 'label'}, 'top5err') ;
% -------------------------------------------------------------------------
%                                                              Prepare data
% -------------------------------------------------------------------------
disp('--> Prepare data...');
if exist(opts.imdbPath, 'file')
  imdb = load(opts.imdbPath) ;
else
  imdb=cnnSetupDataSimpleNN(trainDir, validDir, [128, 128]);
  mkdir(opts.expDir) ;
  save(opts.imdbPath, '-struct', 'imdb') ;
end

net.meta.classes.name = arrayfun(@(x)sprintf('%d',x),1:2,'UniformOutput',false) ;

% -------------------------------------------------------------------------
%                                                                     Train
% -------------------------------------------------------------------------
disp('--> Training...');
switch opts.networkType
  case 'simplenn', trainfn = @cnn_train ;
  case 'dagnn', trainfn = @cnn_train_dag ;
end
[net, info] = trainfn(net, imdb, getBatch(opts), ...
                      'expDir', opts.expDir, ...
                      net.meta.trainOpts, ...
                      opts.train, ...
                      'val', find(imdb.images.set == 3)) ;
net.meta.data_mean = imdb.images.data_mean;

% -------------------------------------------------------------------------
%                                                                    Deploy
% -------------------------------------------------------------------------
disp('--> Deploy the trained model and save...');
net = cnnDeployNet(net) ;
modelPath = fullfile(opts.expDir, 'net-deployed.mat');
save(modelPath, '-struct', 'net') ;



% --------------------------------------------------------------------
function fn = getBatch(opts)
% --------------------------------------------------------------------
switch lower(opts.networkType)
  case 'simplenn'
    fn = @(x,y) getSimpleNNBatch(x,y) ;
  case 'dagnn'
    bopts = struct('numGpus', numel(opts.train.gpus)) ;
    fn = @(x,y) getDagNNBatch(bopts,x,y) ;
end

% --------------------------------------------------------------------
function [images, labels] = getSimpleNNBatch(imdb, batch)
% --------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;

% --------------------------------------------------------------------
function inputs = getDagNNBatch(opts, imdb, batch)
% --------------------------------------------------------------------
images = imdb.images.data(:,:,:,batch) ;
labels = imdb.images.labels(1,batch) ;
if opts.numGpus > 0
  images = gpuArray(images) ;
end
inputs = {'input', images, 'label', labels} ;




