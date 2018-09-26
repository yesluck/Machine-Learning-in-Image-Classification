%=========================================================================
% script used to test the accuracy of a trained network
%=========================================================================

clc
clear
expDir = 'exp-res2';

% -------------------------------------------------------------------------
%                                                          Setup Matconvnet
% -------------------------------------------------------------------------
disp('--> Setup Matconvnet...');
matconvnetDir = 'E:\DevEnvironmentVS2015\matconvnet-1.0-beta23';
matlabDir = [matconvnetDir, '/matlab'];
run(fullfile(matlabDir, 'vl_setupnn.m'));


% -------------------------------------------------------------------------
%                                                                Load model
% -------------------------------------------------------------------------
disp('--> load model...');
net1 = dagnn.DagNN.loadobj(load([expDir,'\image\net-deployed.mat'])) ;
net1.mode = 'test' ;

% -------------------------------------------------------------------------
%                                                                 Load data
% -------------------------------------------------------------------------
imdb = load([expDir, '\image\imdb.mat']) ;

disp('--> initialize options...');
opts.dataDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset' ;
opts.expDir  = fullfile(expDir, 'image') ;
opts.train.train = find(imdb.images.sets==1) ;
opts.train.val = find(imdb.images.sets==3) ;

% -------------------------------------------------------------------------
%                                                                      Test
% -------------------------------------------------------------------------
disp('--> testing...');
for i = 1:length(opts.train.val)
    index = opts.train.val(i);
    label = imdb.images.label(index);
    % ???????
    im_ =  imread(fullfile(imdb.imageDir.test,imdb.images.name{index}));
    im_ = single(im_);
    im_ = imresize(im_, net1.meta.normalization.imageSize(1:2)) ;
    im_ = bsxfun(@minus, im_, net1.meta.normalization.averageImage) ;
    % ??
    net1.eval({'input',im_}) ;
    scores = net1.vars(net1.getVarIndex('prob')).value ;
    scores = squeeze(gather(scores)) ;

    [bestScore, best] = max(scores) ;
    truth(i) = label;
    pre(i) = best; 
    disp([i, label, best]);
end

% -------------------------------------------------------------------------
%                                                              Print result
% -------------------------------------------------------------------------
accurcy = length(find(pre==truth))/length(truth);
disp(['accurcy = ',num2str(accurcy*100),'%']);


