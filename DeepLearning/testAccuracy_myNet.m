%=========================================================================
% script used to test the accuracy of a trained network
%=========================================================================

clc
expDir = 'exp-mynet';

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
net1 = load([expDir,'\image\net-deployed.mat']) ;


% -------------------------------------------------------------------------
%                                                                 Load data
% -------------------------------------------------------------------------
imdb = load([expDir, '\image\imdb.mat']) ;

disp('--> initialize options...');
opts.dataDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset' ;
opts.expDir  = fullfile(expDir, 'image') ;
opts.train.train = find(imdb.images.set==1) ;
opts.train.val = find(imdb.images.set==3) ;

% -------------------------------------------------------------------------
%                                                                      Test
% -------------------------------------------------------------------------
disp('--> testing...');
validDir = 'G:\ZerongZHENG\Research\CODE\DataAndLearning\cup_dataset\valid_img_forstu';

validLabel = importdata(fullfile(validDir, 'label.txt'));
validLabel.textdata = validLabel.textdata(2:end, 1);

for i = 1:length(opts.train.val)
    imgName = validLabel.textdata(i);
    img = imread(fullfile(validDir, imgName{:}));
    label = validLabel.data(i)+1;

    im_ = single(img) - imdb.images.data_mean;

    res = vl_simplenn(net1, im_,[],[],...
                      'accumulate', 0, ...
                      'mode', 'test', ...
                      'backPropDepth', inf, ...
                      'sync', 0, ...
                      'cudnn', 1) ;

    scores = res(22).x(1,1,:);
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


