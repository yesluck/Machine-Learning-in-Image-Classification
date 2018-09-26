function imdb = cnnSetupData(varargin)
%=========================================================================
% cnnSetupData : save images into a ".imdb" file
%=========================================================================

% -------------------------------------------------------------------------
%                                                        Initialize options
% -------------------------------------------------------------------------
opts.dataDir = fullfile('data','image') ;
opts.lite = false ;
opts = vl_argparse(opts, varargin) ;

% -------------------------------------------------------------------------
%                                                  Load categories metadata
% -------------------------------------------------------------------------
nCls = 6;  % number of categories
for i=1:nCls
  cats{i} = num2str(i);
end

imdb.classes.name = cats ;
imdb.imageDir.train = fullfile(opts.dataDir, 'train_img_forstu') ;
imdb.imageDir.test = fullfile(opts.dataDir, 'valid_img_forstu') ;

% -------------------------------------------------------------------------
%                                  Load image names and labels for training
% -------------------------------------------------------------------------
name = {};
labels = {} ;
imdb.images.sets = [] ;
fprintf('searching training images ...\n') ;
% load "label.txt"
train_label_path = fullfile(imdb.imageDir.train, 'label.txt') ;
train_label_temp = importdata(train_label_path);
temp_l = train_label_temp.data;
temp_n = train_label_temp.textdata;
temp_n = temp_n(2:end, 1);

% get the classes of images
for i=1:numel(temp_l)
    train_label{i} = temp_l(i)+1;
end

% check
if length(train_label) ~= ... 
        length(dir(fullfile(imdb.imageDir.train, '*.jpg')))
    error('training data is not equal to its label!!!');
end

% save the directories of all images
for i = 1:length(train_label)
    name{end+1} = temp_n(i);
    labels{end+1} = train_label{i} ;
    if mod(numel(name), 10) == 0, fprintf('.') ; end
    if mod(numel(name), 500) == 0, fprintf('\n') ; end
    imdb.images.sets(end+1) = 1;%train
end
fprintf('\n');

% shuffle the images
shuffleOrder = randperm(numel(name));
name = name(shuffleOrder);
labels = labels(shuffleOrder);

% -------------------------------------------------------------------------
%                                   Load image names and labels for testing
% -------------------------------------------------------------------------
% load "label.txt"
test_label_path = fullfile(imdb.imageDir.test, 'label.txt') ;
test_label_temp = importdata(test_label_path);
temp_l = test_label_temp.data;
temp_n = test_label_temp.textdata;
temp_n = temp_n(2:end, 1);

% get the classes of images
for i=1:numel(temp_l)
    test_label{i} = temp_l(i)+1;
end

% check
if length(test_label) ~= length(dir(fullfile(imdb.imageDir.test, '*.jpg')))
    error('\n testing data is not equal to its label!!!');
end

% save the directories of all images
for i = 1:length(test_label)
    name{end+1} = temp_n(i);
    labels{end+1} = test_label{i} ;
    if mod(numel(name), 10) == 0, fprintf('.') ; end
    if mod(numel(name), 500) == 0, fprintf('\n') ; end
    imdb.images.sets(end+1) = 3;%test
end
fprintf('\n');


% -------------------------------------------------------------------------
%                                                   Get the final imdb file
% -------------------------------------------------------------------------
labels = horzcat(labels{:}) ;
name = horzcat(name{:});
imdb.images.id = 1:numel(name) ;
imdb.images.name = name ;
imdb.images.label = labels ;